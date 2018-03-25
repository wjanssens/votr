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

  embedded_schema do
    field(:number, :string)
    field(:exp, :date)
    field(:dob, :date)
    field(:c, :string)
    field(:st, :string)
    field(:gn, :string)
    field(:sn, :string)
    field(:gender, :string)
    field(:subject_id, :integer)
  end

  def changeset(%IdentityCard{} = ic, attrs) do
    phone
    |> cast(attrs, [:subject_id, :number, :exp, :st, :c])
    |> validate_required([:subject_id, :number])
  end

  def to_principal(%IdentityCard{} = ic) do
    %Principal{
      id: ic.id,
      subject_id: ic.subject_id,
      kind: "identity_card",
      seq: ic.seq,
      hash: :crypto.hash(:sha512, ic.number),
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
      hash: p.hash,
      number: dn.number,
      exp: Date.from_iso8601(dn.exp),
      dob: Date.from_iso8601(dn.dob),
      c: dn.c,
      st: dn.c,
      gn: ic.gn,
      sn: ic.sn,
      gender: ic.gender
    }
  end
end
