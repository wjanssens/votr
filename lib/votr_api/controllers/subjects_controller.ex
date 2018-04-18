import Ecto.Query

defmodule Votr.Api.SubjectsController do
  use VotrWeb, :controller
  use Timex
  alias Votr.Identity.Subject
  alias Votr.Identity.Email
  alias Votr.Identity.Password
  alias Votr.Identity.Token
  alias Votr.Repo

  def index(conn, _params) do
    json(conn, Repo.all(from(s in Subject, select: s.id)))
  end

  # register for a new account
  def create(conn, params) do
    shard = FlexId.make_partition(params.username)
    subject_id = FlexId.generate(:id_generator, shard)

    existing = Email.select(params.username)

    if is_nil(existing) do
      case Repo.transaction(
             fn ->
               %Subject{
                 id: subject_id
               }
               |> Repo.insert!()

               Email.changeset(%Email{}, %{
                 id: FlexId.generate(:id_generator, shard),
                 subject_id: subject_id,
                 seq: 1,
                 address: params.username,
                 label: "other",
                 failures: 10
               })
               |> Repo.insert!()

               Password.changeset(%Password{}, %{
                 id: FlexId.generate(:id_generator, shard),
                 subject_id: subject_id,
                 password: params.password
               })
               |> Repo.insert!()

               Token.changeset(%Token{}, %{
                 id: FlexId.generate(:id_generator, shard),
                 subject_id: subject_id,
                 usage: "email",
                 value: params.username,
                 expiry:
                   Timex.now()
                   |> Timex.add(Timex.Duration.from_days(4))
                   |> Timex.to_datetime()
               })
               |> Repo.insert!()
             end
           ) do
        {:ok, _} ->
          conn
          |> Plug.Conn.send_resp(
               201,
               %{
                 success: true
               }
             )
        {:error, _} ->
          conn
          |> Plug.Conn.send_resp(
               409,
               %{
                 success: false
               }
             )
      end


    else
      response = %{
        success: false,
        message: "A user with this email address already exists."
      }
      conn
      |> Plug.Conn.send_resp(400, response)
    end
  end
end
