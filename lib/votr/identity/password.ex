defmodule Votr.Identity.Password do
  @moduledoc """
  Passwords are used by election officials to log in.
  """
  @config Application.get_env(:votr, Votr.Identity.Password)
  @options @config[:options]
  @algo @config[:algorithm]

  use Ecto.Schema
  import Ecto.Query
  alias Votr.Repo
  alias Votr.Identity.Password
  alias Votr.Identity.Principal

  embedded_schema do
    field(:subject_id, :integer)
    field(:version, :integer)
    field(:hash, :string)
  end

  def delete_by_subject_id(subject_id) do
    from(p in Principal, where: p.kind == "password" and p.subject_id == ^subject_id)
    |> Repo.delete_all()
  end

  def select_by_subject_id(subject_id) do
    from(p in Principal, where: p.kind == "password" and p.subject_id == ^subject_id)
    |> Repo.one()
    |> Password.from_principal()
  end

  def insert(subject_id, hash) do
    %Password{
      subject_id: subject_id,
      hash: hash
    }
    |> insert()
  end

  def insert(%Password{} = p) do
    to_principal(p)
    |> Principal.insert(&from_principal/1)
  end

  def to_principal(%Password{} = p) do
    %Principal{
      id: p.id,
      subject_id: p.subject_id,
      kind: "password",
      value: p.hash
    }
  end

  def from_principal(%Principal{} = p) do
    %Password{
      id: p.id,
      subject_id: p.subject_id,
      hash: p.value
    }
  end

  def hash(plaintext, algo \\ @algo, opts \\ @options) do
    case algo do
      :ldap ->
        ldap(plaintext, opts)

      :pbkdf2 ->
        pbkdf2(plaintext, opts)

      :argon2 ->
        argon2(plaintext, opts)

      :bcrypt ->
        bcrypt(plaintext, opts)
    end
  end

  def ldap(plaintext, opts) do
    digest = Map.get(opts, :digest, :sha512)
    salt_len = Map.get(opts, :salt_len, 16)
    salt = :crypto.strong_rand_bytes(salt_len)
    hash = :crypto.hash(digest, plaintext <> salt)
    scheme = ("S" <> digest)
             |> Atom.to_string()
    "$#{scheme}$#{Base.encode64(salt)}$#{Base.encode64(hash)}"
  end

  def pbkdf2(plaintext, opts) do
    Pbkdf2.hash_pwd_salt(plaintext, opts)
  end

  def argon2(plaintext, opts) do
    Argon2.hash_pwd_salt(plaintext, opts)
  end

  def bcrypt(plaintext, opts) do
    Bcrypt.hash_pwd_salt(plaintext, opts)
  end

  def verify(subject_id, plaintext) do
    with password <- Password.select_by_subject_id(subject_id) do
      [_blank | [ scheme | _rest]] = String.split(password.hash, ~r{\$})

      valid = cond do
        Enum.member?(["smd5", "ssha", "ssha224", "ssha256", "ssha384", "ssha512"], scheme) ->
          verify_ldap(plaintext, password.hash)

        Enum.member?(["argon2d", "argon2i", "argon2id"], scheme) ->
          verify_argon2(plaintext, password.hash)

        Enum.member?(["2a", "2b"], scheme) ->
          verify_bcrypt(plaintext, password.hash)

        String.match?(scheme, ~r{pbkdf2-}) ->
          verify_pbkdf2(plaintext, password.hash)

        true ->
          false
      end

      if valid, do: {:ok, :valid}, else: {:error, :invalid} end
  end

  defp verify_ldap(plaintext, hash) do
    [scheme, salt, hash] = String.split(hash, ~r{\$})
    salt = Base.decode64(salt)
    digest = scheme
             |> String.slice(1..-1)
             |> String.to_atom()
    hash == :crypto.hash(digest, plaintext <> salt)
  end

  defp verify_bcrypt(plaintext, hash) do
    Bcrypt.verify_pass(plaintext, hash)
  end

  defp verify_argon2(plaintext, hash) do
    Argon2.verify_pass(plaintext, hash)
  end

  defp verify_pbkdf2(plaintext, hash) do
    Pbkdf2.verify_pass(plaintext, hash)
  end
end
