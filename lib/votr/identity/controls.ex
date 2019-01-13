defmodule Votr.Identity.Controls do
  @moduledoc """
  Account controls enable security features.
  """

  @config Application.get_env(:votr, Votr.Identity.Controls)
  @lock_sec @config[:lock_sec]

  use Ecto.Schema
  alias Votr.Identity.Controls
  alias Votr.Identity.Principal
  alias Votr.Identity.DN

  embedded_schema do
    field(:subject_id, :integer)
    field(:version, :integer)
    field(:verified_at, :utc_datetime)
    field(:locked_at, :utc_datetime)
    field(:login_at, :utc_datetime)
    field(:escalate_at, :utc_datetime)
    field(:failures, :integer)
  end

  def select_by_subject_id(subject_id) do
    case Principal.select_by_subject_id(subject_id, "controls", &from_principal/1)
         |> Enum.at(0)
      do
      nil -> {:error, :not_found}
      controls -> {:ok, controls}
    end
  end

  def insert(%Controls{} = c) do
    c
    |> to_principal
    |> Principal.insert(&from_principal/1)
  end

  def update(%Controls{} = c) do
    c
    |> to_principal
    |> Principal.change(&from_principal/1)
  end

  def to_principal(%Controls{} = c) do
    %Principal{
      id: c.id,
      version: c.version,
      subject_id: c.subject_id,
      kind: "controls",
      seq: 0,
      value:
        %{
          verified_at: try do
            DateTime.to_iso8601(c.verified_at)
          rescue _ -> nil
          end,
          locked_at: try do
            DateTime.to_iso8601(c.locked_at)
          rescue _ -> nil
          end,
          login_at: try do
            DateTime.to_iso8601(c.login_at)
          rescue _ -> nil
          end,
          escalate_at: try do
            DateTime.to_iso8601(c.escalate_at)
          rescue _ -> nil
          end,
          failures: Integer.to_string(c.failures)
        }
        |> DN.to_string()
    }
  end

  def from_principal(%Principal{} = p) do
    dn =
      p.value
      |> DN.from_string()

    %Controls{
      id: p.id,
      subject_id: p.subject_id,
      locked_at: try do
        DateTime.from_iso8601(dn.locked_at)
      rescue _ -> nil
      end,
      login_at: try do
        DateTime.from_iso8601(dn.login_at)
      rescue _ -> nil
      end,
      escalate_at: try do
        DateTime.from_iso8601(dn.escalate_at)
      rescue _ -> nil
      end,
      failures: try do
        String.to_integer(dn.failures)
      rescue _ -> 0
      end
    }
  end

  def verify(subject_id) do
    IO.inspect("here #{subject_id}")
    with {:ok, controls} <- Controls.select_by_subject_id(subject_id) do

      IO.inspect(controls)
      now = DateTime.utc_now()
            |> DateTime.to_unix()

      locked = case controls.locked_at do
        nil -> false
        _ -> DateTime.to_unix(controls.locked_at) + @lock_sec < now
      end

      if locked, do: {:error, :locked}, else: {:ok, controls}
    else
      _ -> IO.inspect({:error, :not_found})
    end
  end
end
