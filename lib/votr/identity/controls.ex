defmodule Votr.Identity.Controls do
  @moduledoc """
  Account controls enable security features.
  """
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

  def to_principal(%Controls{} = c) do
    %Principal{
      id: c.id,
      subject_id: c.subject_id,
      kind: "controls",
      seq: 0,
      value:
        %{
          verified_at: try do DateTime.to_iso8601(c.verified_at) rescue _ -> nil end,
          locked_at: try do DateTime.to_iso8601(c.locked_at) rescue _ -> nil end,
          login_at: try do DateTime.to_iso8601(c.login_at) rescue _ -> nil end,
          escalate_at: try do DateTime.to_iso8601(c.escalate_at) rescue _ -> nil end,
          failures: c.failures
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
      verified_at: try do DateTime.from_iso8601(dn.verified_at) rescue _ -> nil end,
      locked_at: try do DateTime.from_iso8601(dn.locked_at) rescue _ -> nil end,
      login_at: try do DateTime.from_iso8601(dn.login_at) rescue _ -> nil end,
      escalate_at: try do DateTime.from_iso8601(dn.escalate_at) rescue _ -> nil end,
      failures: try do String.to_integer(dn.failures) rescue _ -> 0 end
    }
  end
end
