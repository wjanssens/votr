defmodule Votr.Identity.ChallengeResponse do
  use Ecto.Schema
  import Ecto.Changeset
  alias Votr.Identity.ChallengeResponse
  alias Votr.Identity.Principal
  alias Votr.Identity.DN

  embedded_schema do
    field(:c, :string)
    field(:r, :string)
    field(:seq, :integer)
    field(:subject_id, :integer)
  end

  def changeset(%ChallengeResponse{} = cr, attrs) do
    cr
    |> cast(attrs, [:subject_id, :c, :r])
    |> validate_required([:subject_id, :c, :r])
  end

  def to_principal(%ChallengeResponse{} = cr) do
    %Principal{
      id: cr.id,
      subject_id: cr.subject_id,
      kind: "challenge_response",
      seq: cr.seq,
      value:
        %{c: cr.c, r: cr.r}
        |> DN.to_string()
        |> AES.encrypt()
        |> Base.encode64()
    }
  end

  def from_principal(%Principal{} = p) do
    dn =
      p.value
      |> Base.decode64()
      |> AES.decrypt()
      |> DN.from_string()

    %ChallengeResponse{
      id: p.id,
      subject_id: p.subject_id,
      c: dn.c,
      r: dn.r,
      seq: p.seq
    }
  end
end
