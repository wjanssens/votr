defmodule Votr.Identity.StructuredAddress do
  @moduledoc """
  Postal addresses may be used to deliver ballots to voters.
  """
  use Ecto.Schema
  import Ecto.Changeset
  alias Votr.Identity.StructuredAddress
  alias Votr.Identity.Principal
  alias Votr.Identity.DN

  embedded_schema do
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
    field(:status, :string)
    field(:seq, :integer)
    field(:subject_id, :integer)
  end

  def changeset(%StructuredAddress{} = address, attrs) do
    address
    |> cast(attrs, [:subject_id, :sequence, :lines, :label, :status])
    |> validate_required([:subject_id, :street, :l, :pc, :c, :status])
    |> validate_inclusion(:label, ["home", "work", "other"])
    |> validate_inclusion(:status, ["unverified", "valid", "invalid"])
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
      status: dn.status,
      seq: p.seq
    }
  end

  def format(%StructuredAddress{} = a, origin_country) do
    # TODO add more formats

    c = a.c
    same = a.c == origin_country
    # TODO need to format the country name
    country = if same, do: nil, else: a.c

    formatted = fn
      a when Enum.member?(["AU", "CA", "PR", "US"], c) ->
        "#{a.title} #{a.gn} #{a.initials} #{a.sn}\n#{a.o}\n#{a.street}\n#{a.po}\n#{a.l}, #{a.st} #{
          a.pc
        }\n#{country}"

      a when Enum.member?(["AR", "EC", "CL", "CO", "PE", "VE"], c) ->
        "#{a.title} #{a.gn} #{a.initials} #{a.sn}\n#{a.o}\n#{a.street}\n#{a.po}\n#{a.pc} #{a.l}\n#{
          a.st
        }\n#{country}"

      a when "MX" == c ->
        "#{a.title} #{a.gn} #{a.initials} #{a.sn}\n#{a.o}\n#{a.street}\n#{a.po}\n#{a.pc} #{a.l}, #{
          a.st
        }\n#{country}"

      a when "BR" == c ->
        "#{a.o}\n#{a.title} #{a.gn} #{a.initials} #{a.sn}\n#{a.street}\n#{a.po}\n#{a.l} - #{a.st}\n#{
          a.pc
        }\n#{country}"

      # western europe
      a when "AU" == c ->
        "#{a.title} #{a.gn} #{a.initials} #{a.sn}\n#{a.o}\n#{a.street}\n#{a.pc} #{
          String.upcase(a.l)
        }\n#{country}"

      a when "BE" == c ->
        "#{a.title} #{a.gn} #{a.initials} #{a.sn}\n#{a.o}\n#{a.street}\n#{a.po}\n#{a.pc} #{a.l}\n#{
          country
        }"

      a when "CH" == c ->
        "#{a.title} #{a.gn} #{a.sn}\n#{a.street}\n#{a.pc} #{a.l}\n#{country}"

      a when "CZ" == c ->
        "#{a.title} #{a.gn} #{a.initials} #{a.sn}\n#{a.o}\n#{a.street}\n#{a.po}\n#{a.pc} #{a.l}\n#{
          country
        }"

      a when "DE" == c ->
        "#{a.title} #{a.gn} #{a.initials} #{a.sn}\n#{a.o}\n#{a.street}\n#{a.po}\n#{a.pc} #{a.l}\n#{
          country
        }"

      a when "DK" == c ->
        prefix = if same, do: "", else: "DK-"

        "#{a.title} #{a.gn} #{a.initals} #{a.sn}\n#{a.o}\n#{a.street}\n#{a.po}\n#{prefix}#{a.pc} #{
          a.l
        }\n#{country}"

      a when "FI" == c ->
        "#{a.o}\n#{a.title} #{a.gn} #{a.initials} #{a.sn}\n#{a.street}\n#{a.po}\n#{a.pc} #{a.l}\n#{
          country
        }"

      a when "FR" == c ->
        prefix = if same, do: "", else: "FR-"
        surname = a.sn |> String.upcase()

        "#{a.o}\n#{a.title} #{a.gn} #{a.initials} #{surname}\n#{a.street}\n#{a.po}\n#{prefix}#{
          a.pc
        } #{a.l}\n#{country}"

      a when "HU" == c ->
        "#{a.title} #{a.gn} #{a.initials} #{a.sn}\n#{a.o}\n#{a.l}\n#{a.street}\n#{a.pc}\n#{
          country
        }"

      a when "IT" == c ->
        prefix = if same, do: "", else: "IT-"

        "#{a.title} #{a.gn} #{a.initials} #{a.sn}\n#{a.o}\n#{a.street}\n#{a.po}\n#{prefix}#{a.pc} #{
          a.l
        } #{a.st}\n#{country}"

      a when "NL" == c ->
        "#{a.o}\n#{a.ou}\n#{a.title} #{a.gn} #{a.initials} #{a.sn}\n#{a.street}\n#{a.po}\n#{a.pc} #{
          a.st
        } #{a.l}\n#{country}"

      a when "NO" == c ->
        "#{a.o}\n#{a.street}\n#{a.gn} #{a.sn}\n#{a.po}\n#{a.pc} #{a.l}\n#{country}"

      a when "PT" == c ->
        "#{a.title} #{a.gn} #{a.initials} #{a.sn}\n#{a.o}\n#{a.street}\n#{a.po}\n#{a.l}\n#{a.pc}\n#{
          country
        }"

      a when "SE" == c ->
        "#{a.o}\n#{a.gn} #{a.sn}\n#{a.street}\n#{a.po}\n#{a.pc} #{a.l}\n#{country}"

      # british isles
      a when "GB" == c ->
        post_town = String.upcase(a.po)

        "#{a.title} #{a.gn} #{a.initials} #{a.sn}\n#{a.o}\n#{a.street}\n#{a.l}\n#{post_town}\n#{
          a.pc
        }\n#{country}"

      # asia
      a when Enum.member?(["KP", "KR"], c) ->
        "#{country}\n#{a.pc}\n#{a.st} #{a.l} #{a.street}\n#{a.o}\n#{a.sn} #{a.gn} #{a.title}"

      a when "CN" == c ->
        "#{country}\n#{a.st} #{a.l}\n#{a.street}\n#{a.sn} #{a.gn} #{a.title}"

      a when "JP" == c ->
        "#{country}\n#{a.pc} #{a.st} #{a.l}\n#{a.street}\n#{a.o}\n#{a.sn} #{a.gn} #{a.title}"

      a when "MY" == c ->
        "#{a.title} #{a.gn} #{a.initials} #{a.sn}\n#{a.o}\n#{a.street}\n#{a.po}\n#{a.pc} #{a.l}\n#{
          a.st
        } #{country}"

      # slavic
      a when "BG" == c ->
        "#{country}\n#{a.st}\n#{a.pc} #{a.l}\n#{a.street}\n#{a.po}\n#{a.o}\n#{a.title} #{a.gn} #{
          a.initals
        } #{a.sn}"

      a when "RU" == c ->
        "#{country}\n#{a.pc}\n#{a.st} #{a.l}\n#{a.street}\n#{a.po}\n#{a.o}\n#{a.sn} #{a.gn} #{
          a.initials
        }"

      # international format
      a ->
        "#{a.title} #{a.gn} #{a.initials} #{a.sn}\n#{a.ou}\n#{a.o}\n#{a.street}\n#{a.po}\n#{a.l}, #{
          a.st
        } #{a.pc}\n#{country}"
    end

    formatted.(a)
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
