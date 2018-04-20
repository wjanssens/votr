defmodule Votr.Identity.Email do
  @moduledoc """
  Email addresses may be used to communicate with election officials.
  Email addresses may be used to deliver ballots to voters.
  """
  use Ecto.Schema
  alias Votr.Identity.Email
  alias Votr.Identity.Principal
  alias Votr.Identity.DN
  alias Votr.AES

  embedded_schema do
    field(:subject_id, :integer)
    field(:version, :integer)
    field(:seq, :integer)
    field(:address, :string)
    field(:label, :string)
    field(:state, :string)
  end

  def select_by_id(id) do
    Principal.select(id, &from_principal/1)
  end

  def select_by_address(address) do
    Principal.select_by_hash(address, &from_principal/1, fn e -> e.address == address end)
  end

  def insert(subject_id, address, seq \\ 1, label \\ "other", state \\ "invalid") do
    %Email{
      subject_id: subject_id,
      address: address,
      seq: seq,
      label: label,
      state: state
    }
    |> insert()
  end

  def insert(%Email{} = e) do
    to_principal(e)
    |> Principal.insert(&from_principal/1)
  end

  def update(%Email{} = e) do
    to_principal(e)
    |> Principal.update(&from_principal/1)
  end

  def to_principal(%Email{} = e) do
    %Principal{
      id: e.id,
      subject_id: e.subject_id,
      kind: "email",
      value: %{address: e.address, label: e.label, failures: Integer.to_string(e.failures)}
             |> DN.to_string()
             |> AES.encrypt()
             |> Base.encode64(),
      hash: :crypto.hash(:sha256, e.address)
            |> Base.encode64
    }
  end

  def from_principal(%Principal{} = p) do
    dn =
      p.value
      |> Base.decode64()
      |> AES.decrypt()
      |> DN.from_string()

    %Email{
      id: p.id,
      subject_id: p.subject_id,
      address: dn.address,
      label: dn.label,
      state: dn.state,
      seq: p.seq
    }
  end
end
