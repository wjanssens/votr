defmodule Votr.Identity.StructuredAddress do
  @moduledoc """
  Postal addresses may be used to deliver ballots to voters.
  """
  use Ecto.Schema
  import Ecto.Changeset
  alias Votr.Identity.StructuredAddress
  alias Votr.Identity.Principal
  alias Votr.Identity.DN
  alias Votr.AES

  embedded_schema do
    field(:subject_id, :integer)
    field(:version, :integer)
    field(:seq, :integer)
    field(:title, :string)
    # given name
    field(:gn, :string)
    field(:initials, :string)
    # surname
    field(:sn, :string)
    # organization
    field(:o, :string)
    # organizational unit
    field(:ou, :string)
    field(:street, :string)
    # post office box, post town, neighborhood
    field(:po, :string)
    # locality, si
    field(:l, :string)
    # state, province, prefecture, do
    field(:st, :string)
    # postal code
    field(:pc, :string)
    # country
    field(:c, :string)
    field(:label, :string)
    field(:failures, :integer)
  end

  def changeset(%StructuredAddress{} = address, attrs) do
    address
    |> cast(attrs, [
      :subject_id,
      :seq,
      :title,
      :gn,
      :initials,
      :sn,
      :o,
      :ou,
      :street,
      :po,
      :l,
      :st,
      :pc,
      :c,
      :label,
      :integer
    ])
    |> validate_required([:subject_id, :seq, :street, :l, :pc, :c, :label, :failures])
    |> validate_inclusion(:label, ["home", "work", "other"])
    |> Map.update(:version, 0, &(&1 + 1))
    |> to_principal
  end

  def to_principal(%StructuredAddress{} = address) do
    %Principal{
      id: address.id,
      subject_id: address.subject_id,
      kind: "full_address",
      seq: address.seq,
      value:
        address
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

    %StructuredAddress{
      id: p.id,
      subject_id: p.subject_id,
      title: dn.title,
      gn: dn.gn,
      initials: dn.initials,
      sn: dn.sn,
      o: dn.o,
      ou: dn.ou,
      street: dn.street,
      po: dn.po,
      l: dn.l,
      st: dn.st,
      pc: dn.pc,
      c: dn.c,
      label: dn.label,
      failures: String.to_integer(dn.failures),
      seq: p.seq
    }
  end

  def format(%StructuredAddress{} = a, origin_country) do
    # TODO add more formats

    c = a.c
    same = a.c == origin_country
    # TODO need to format the country name
    country = if same, do: nil, else: a.c

    formatted = cond do
      Enum.member?(["AU", "CA", "PR", "US"], c) ->
        "#{a.title} #{a.gn} #{a.initials} #{a.sn}\n#{a.o}\n#{a.street}\n#{a.po}\n#{a.l}, #{a.st} #{
          a.pc
        }\n#{country}"

      Enum.member?(["AR", "EC", "CL", "CO", "PE", "VE"], c) ->
        "#{a.title} #{a.gn} #{a.initials} #{a.sn}\n#{a.o}\n#{a.street}\n#{a.po}\n#{a.pc} #{a.l}\n#{
          a.st
        }\n#{country}"

      "MX" == c ->
        "#{a.title} #{a.gn} #{a.initials} #{a.sn}\n#{a.o}\n#{a.street}\n#{a.po}\n#{a.pc} #{a.l}, #{
          a.st
        }\n#{country}"

      "BR" == c ->
        "#{a.o}\n#{a.title} #{a.gn} #{a.initials} #{a.sn}\n#{a.street}\n#{a.po}\n#{a.l} - #{a.st}\n#{
          a.pc
        }\n#{country}"

      # western europe
      "AU" == c ->
        "#{a.title} #{a.gn} #{a.initials} #{a.sn}\n#{a.o}\n#{a.street}\n#{a.pc} #{
          String.upcase(a.l)
        }\n#{country}"

      "BE" == c ->
        "#{a.title} #{a.gn} #{a.initials} #{a.sn}\n#{a.o}\n#{a.street}\n#{a.po}\n#{a.pc} #{a.l}\n#{
          country
        }"

      "CH" == c ->
        "#{a.title} #{a.gn} #{a.sn}\n#{a.street}\n#{a.pc} #{a.l}\n#{country}"

      "CZ" == c ->
        "#{a.title} #{a.gn} #{a.initials} #{a.sn}\n#{a.o}\n#{a.street}\n#{a.po}\n#{a.pc} #{a.l}\n#{
          country
        }"

      "DE" == c ->
        "#{a.title} #{a.gn} #{a.initials} #{a.sn}\n#{a.o}\n#{a.street}\n#{a.po}\n#{a.pc} #{a.l}\n#{
          country
        }"

      "DK" == c ->
        prefix = if same, do: "", else: "DK-"

        "#{a.title} #{a.gn} #{a.initals} #{a.sn}\n#{a.o}\n#{a.street}\n#{a.po}\n#{prefix}#{a.pc} #{
          a.l
        }\n#{country}"

      "FI" == c ->
        "#{a.o}\n#{a.title} #{a.gn} #{a.initials} #{a.sn}\n#{a.street}\n#{a.po}\n#{a.pc} #{a.l}\n#{
          country
        }"

      "FR" == c ->
        prefix = if same, do: "", else: "FR-"
        surname = a.sn |> String.upcase()

        "#{a.o}\n#{a.title} #{a.gn} #{a.initials} #{surname}\n#{a.street}\n#{a.po}\n#{prefix}#{
          a.pc
        } #{a.l}\n#{country}"

      "HU" == c ->
        "#{a.title} #{a.gn} #{a.initials} #{a.sn}\n#{a.o}\n#{a.l}\n#{a.street}\n#{a.pc}\n#{
          country
        }"

      "IT" == c ->
        prefix = if same, do: "", else: "IT-"

        "#{a.title} #{a.gn} #{a.initials} #{a.sn}\n#{a.o}\n#{a.street}\n#{a.po}\n#{prefix}#{a.pc} #{
          a.l
        } #{a.st}\n#{country}"

      "NL" == c ->
        "#{a.o}\n#{a.ou}\n#{a.title} #{a.gn} #{a.initials} #{a.sn}\n#{a.street}\n#{a.po}\n#{a.pc} #{
          a.st
        } #{a.l}\n#{country}"

      "NO" == c ->
        "#{a.o}\n#{a.street}\n#{a.gn} #{a.sn}\n#{a.po}\n#{a.pc} #{a.l}\n#{country}"

      "PT" == c ->
        "#{a.title} #{a.gn} #{a.initials} #{a.sn}\n#{a.o}\n#{a.street}\n#{a.po}\n#{a.l}\n#{a.pc}\n#{
          country
        }"

      "SE" == c ->
        "#{a.o}\n#{a.gn} #{a.sn}\n#{a.street}\n#{a.po}\n#{a.pc} #{a.l}\n#{country}"

      # british isles
      "GB" == c ->
        post_town = String.upcase(a.po)

        "#{a.title} #{a.gn} #{a.initials} #{a.sn}\n#{a.o}\n#{a.street}\n#{a.l}\n#{post_town}\n#{
          a.pc
        }\n#{country}"

      # asia
      Enum.member?(["KP", "KR"], c) ->
        "#{country}\n#{a.pc}\n#{a.st} #{a.l} #{a.street}\n#{a.o}\n#{a.sn} #{a.gn} #{a.title}"

      "CN" == c ->
        "#{country}\n#{a.st} #{a.l}\n#{a.street}\n#{a.sn} #{a.gn} #{a.title}"

      "JP" == c ->
        "#{country}\n#{a.pc} #{a.st} #{a.l}\n#{a.street}\n#{a.o}\n#{a.sn} #{a.gn} #{a.title}"

      "MY" == c ->
        "#{a.title} #{a.gn} #{a.initials} #{a.sn}\n#{a.o}\n#{a.street}\n#{a.po}\n#{a.pc} #{a.l}\n#{
          a.st
        } #{country}"

      # slavic
      "BG" == c ->
        "#{country}\n#{a.st}\n#{a.pc} #{a.l}\n#{a.street}\n#{a.po}\n#{a.o}\n#{a.title} #{a.gn} #{
          a.initals
        } #{a.sn}"

      "RU" == c ->
        "#{country}\n#{a.pc}\n#{a.st} #{a.l}\n#{a.street}\n#{a.po}\n#{a.o}\n#{a.sn} #{a.gn} #{
          a.initials
        }"

      # fallback international format
      a ->
        "#{a.title} #{a.gn} #{a.initials} #{a.sn}\n#{a.ou}\n#{a.o}\n#{a.street}\n#{a.po}\n#{a.l}, #{
          a.st
        } #{a.pc}\n#{country}"
    end

    formatted
    # remove extra space at start of line
    |> String.replace(~r{^\s*}, "")
    # remove duplicate spaces
    |> String.replace(~r{\s+}, " ")
    # remove empty lines
    |> String.replace(~r{\n+}, "\n")
    # insert required empty lines
    |> String.replace("\x1f", "\n")
  end
end
