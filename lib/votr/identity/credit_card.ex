defmodule Votr.Identity.CreditCard do
  @moduledoc """
  Credit cards may be retained for subjects that need to pay for their election results.
  """
  use Ecto.Schema
  import Ecto.Changeset
  alias Votr.Identity.IdentityCard
  alias Votr.Identity.Principal
  alias Votr.Identity.DN

  embedded_schema do
    field(:subject_id, :integer)
    field(:seq, :integer)
    field(:number, :string)
    field(:exp, :date)
  end

  def changeset(%IdentityCard{} = ic, attrs) do
    phone
    |> cast(attrs, [:subject_id, :seq, :number, :exp])
    |> validate_required([:subject_id, :seq, :number, :exp])
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
          c: ic.c,
          st: ic.st,
          dob: Date.to_iso8601(ic.dob),
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

    %Phone{
      id: p.id,
      subject_id: p.subject_id,
      number: dn.number,
      label: dn.label,
      status: dn.status,
      seq: p.seq
    }
  end
end
