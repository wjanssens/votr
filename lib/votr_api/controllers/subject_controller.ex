import Ecto.Query

defmodule Votr.Api.SubjectController do
  use VotrWeb, :controller
  use Timex
  alias Votr.Identity.Subject
  alias Votr.Identity.Email
  alias Votr.Identity.Password
  alias Votr.Identity.Token

  def index(conn, _params) do
    json(conn, Repo.all(from(s in Subject, select: s.id)))
  end

  # register for a new account
  def create(conn, params) do
    shard = FlexId.make_partition(params.username)
    subject_id = FlexId.generate(agent, shard)

    existing =
      Email.select(:crypto.hash(:sha512, params.username))
      |> Enum.filter(fn e -> e.address == params.username end)
      |> Enum.at(0, nil)

    if is_nil(existing) do
      conn
      |> Plug.Conn.send_resp(400, error)
    else
      subject = %Subject{
        id: subject_id
      }

      email = %Email{
        id: FlexId.generate(agent, shard),
        subject_id: subject_id,
        seq: 1,
        username: params.username,
        label: "other",
        failures: 10
      }

      password = %Password{
        id: FlexId.generate(agent, shard),
        subject_id: subject_id,
        password: params.password
      }

      token = %Token{
        id: FlexId.generate(agent, shard),
        subject_id: subject_id,
        usage: "email",
        value: params.username,
        expiry:
          Timex.now()
          |> Timex.add(Timex.Duration.from_days(4))
          |> Timex.to_datetime()
      }

      conn
      |> Plug.Conn.send_resp(201, response)
    end
  end
end
