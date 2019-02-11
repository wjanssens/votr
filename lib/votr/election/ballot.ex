defmodule Votr.Election.Ballot do
  use Ecto.Schema
  import Ecto.Changeset
  import Ecto.Query
  alias Votr.AES
  alias Votr.HashId
  alias Votr.Repo
  alias Votr.Election.Ballot
  alias Votr.Election.Res
  alias Votr.Election.Ward

  @primary_key {:id, :integer, autogenerate: false}
  @timestamps_opts [type: :utc_datetime, usec: true]
  schema "ballot" do
    belongs_to :ward, Ward
    field :version, :integer
    field :seq, :integer              # the order in which ballots are presented to the voter
    field :ext_id, :string            # reference to an external system
    field :method, :string            # the count method (eg. scottish_stv, approval, plurality)
    field :quota, :string             # the quota (eg. droop, hare)
    field :electing, :integer         # how many candidates are being elected
    field :shuffle, :boolean          # candidates are displayed to the voter in a random order
    field :mutable, :boolean          # voters can change their vote
    field :public, :boolean           # results are publicly available
    field :color, :string             # used to color ballots to help distinguish multiple ballots in a ward
    has_many :strings, Res, foreign_key: :entity_id, on_delete: :delete_all
    timestamps()
  end

  @doc false
  def changeset(ballot, attrs) do
    ballot
    |> cast(attrs, [])
    |> validate_required([])
    #    |> validate_inclusion(:method, ["scottish_stv", "meek_stv", "plurality", "approval", "condorcet"])
    #    |> validate_includion(:quota,  ["droop", "hare", "imperator", "hagenback-bischoff"])
  end

  def upsert(ward_id, ballot) do
    shard = FlexId.extract_partition(:id_generator, ward_id)

    ballot
    |> Map.put_new_lazy(:id, fn -> FlexId.generate(:id_generator, shard)  end)
    |> cast(
         %{},
         [:id, :ward_id, :version, :seq, :ext_id, :method, :quota, :electing, :shuffle, :mutable, :public, :color]
       )
    |> validate_required([:method, :version, :subject_id, :seq, :method, :electing])
    |> optimistic_lock(:version)
    |> Votr.Repo.insert
  end

  @doc """
    Gets all of the ballots for a ward.
  """
  def select_all(subject_id, ward_id) do
    Votr.Repo.all from b in Ballot,
                  join: w in assoc(b, :ward),
                  join: s in assoc(b, :strings),
                  preload: [
                    strings: s
                  ],
                  where: b.ward_id == ^ward_id and w.subject_id == ^subject_id,
                  select: b
  end

  @doc """
    Gets all of the ballots for a voter with ward and candidates.
    Name and description values will be in the requested language or the default language.
    [
      %{id: 1,
        name: "string",
        description: "string",
        ward: %{id: 1,
                start: datetime,
                end: datetime,
                name: "string"
                description: "string"},
        candidates: [
          %{id: 1,
            name: "string",
            description: "string"}, ...
      }, ...
    ]
  """
  def select_for_voter(voter_id, lang_tag) do
    types = %{
      ballot_id: :integer,
      ballot_name: :string,
      ballot_desc: :string,
      ward_id: :integer,
      ward_name: :string,
      ward_desc: :string,
      start_at: :utc_datetime,
      end_at: :utc_datetime,
      candidate_id: :integer,
      candidate_name: :string,
      candidate_desc: :string
    }

    # TODO this could be changed to take a list of acceptable lang tags instead of just one

    results =
      """
      with recursive heirarchy (id, parent_id, start_at, end_at) as (
        select w.id, w.parent_id, w.start_at, w.end_at
        from ward w
        inner join voter v on v.parent_id = w.id
        where v.id = $1
        union all
        select p.id, p.parent_id, p.start_at, p.end_at
        from ward p
        inner join heirarchy h on p.id = h.parent_id
      ), data (ward_id, ward_seq, start_at, end_at, ballot_id, ballot_seq, candidate_id, candidate_seq) as
        select w.id, w.seq, w.start_at, w.end_at, b.id, b.seq, c.id, c.seq
        from heirarchy w
        inner join ballot b on b.ward_id = w.id
        inner join candidate c on c.ballot_id = b.id
      ), strings (entity_id, key, value, rn) as (
        select entity_id, key, value, row_number() over (partition by entity_id order by nullif(tag, 'default') nulls last)
        from res r
        inner join data on r.entity_id = w.id or r.entity_id = b.id or r.entity_id = c.id
        where r.tag = $2 or r.tag = 'default'
      )
      select ballot_id, bn.value ballot_name, bd.value ballot_desc,
             ward_id, start_at, end_at, wn.value ward_name, wd.value ward_desc,
             candidate_id, cn.value candidate_name, cd.value candidate_desc
      from data
      inner join strings bn on bn.entity_id = ballot_id and bn.key = 'name' and bn.rn = 1
      left join strings bd on bd.entity_id = ballot_id and bd.key = 'description' and bd.rn = 1
      inner join strings wn on wn.entity_id = ward_id and wn.key = 'name' and wn.rn = 1
      left join strings wd on wd.entity_id = ward_id and wn.key = 'description' and wd.rn = 1
      inner join strings cn on cn.entity_id = candidate_id and cn.key = 'name' and cn.rn = 1
      left join strings cd on cd.entity_id = candidate_id and cn.key = 'description' and cd.rn = 1
      order by ward_seq, ballot_seq, candidate_seq

      """
      |> Votr.Repo.query!([voter_id, lang_tag])

    all = Enum.map(results.rows, &Repo.load(types, {results.columns, &1}))
    ballots = Enum.uniq_by(all, fn b -> b.ballot_id end)
    candidates = Enum.group_by(all, &(&1.ballot_id))

    ballots
    |> Enum.map(
         fn b ->
           %{
             id: HashId.encode(b.ballot_id),
             name: AES.decrypt(Base.decode64(b.ballot_name)),
             description: AES.decrypt(Base.decode64(b.ballot_desc)),
             ward: %{
               id: HashId.encode(b.ward_id),
               name: AES.decrypt(Base.decode64(b.ward_name)),
               description: AES.decrypt(Base.decode64(b.ward_desc)),
               start: b.start_at,
               end: b.end_at
             },
             candidates: Map.get(candidates, b.ballot_id)
                         |> Enum.map(
                              fn c ->
                                %{
                                  id: HashId.encode(c.candidate_id),
                                  name: AES.decrypt(Base.decode64(c.candidate_name)),
                                  description: AES.decrypt(Base.decode64(c.candidate_desc)),
                                }
                              end
                            )
           }
         end
       )
  end
end
