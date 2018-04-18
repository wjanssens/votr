defmodule Votr.Identity.IdentityCard do
  @moduledoc """
  Identity card numbers may be used as a form of identity confirmation during voting.
  Depending on the country this could be a Citizen Card, Passport Card,
  Voter Card, PAN card, Drivers License, Passport, Tax Number, etc...
  Only the number is required as it is what will be verified.
  """
  use Ecto.Schema
  import Ecto.Changeset
  alias Votr.Identity.IdentityCard
  alias Votr.Identity.Principal
  alias Votr.Identity.DN
  alias Votr.AES

  embedded_schema do
    field(:subject_id, :integer)
    field(:version, :integer)
    field(:seq, :integer)
    field(:number, :string)
    field(:exp, :date)
    field(:dob, :date)
    field(:c, :string)
    field(:st, :string)
    field(:gn, :string)
    field(:sn, :string)
    field(:gender, :string)
  end

  def changeset(%IdentityCard{} = card, attrs) do
    card
    |> cast(attrs, [:subject_id, :seq, :number, :exp, :dob, :c, :st, :gn, :sn, :gender])
    |> validate_required([:subject_id, :seq, :number])
    |> Map.update(:version, 0, &(&1 + 1))
    |> to_principal
  end

  def to_principal(%IdentityCard{} = ic) do
    %Principal{
      id: ic.id,
      subject_id: ic.subject_id,
      kind: "identity_card",
      seq: ic.seq,
      hash: :crypto.hash(:sha256, ic.number)
            |> Base.encode64,
      value:
        %{
          number: ic.number,
          exp: Date.to_iso8601(ic.exp),
          dob: Date.to_iso8601(ic.dob),
          c: ic.c,
          st: ic.st,
          gn: ic.gn,
          sn: ic.sn,
          gender: ic.gender
        }
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

    %IdentityCard{
      id: p.id,
      subject_id: p.subject_id,
      seq: p.seq,
      number: dn.number,
      exp: Date.from_iso8601(dn.exp),
      dob: Date.from_iso8601(dn.dob),
      c: dn.c,
      st: dn.c,
      gn: dn.gn,
      sn: dn.sn,
      gender: dn.gender
    }
  end
end
