defmodule Votr.JWT do
  @config Application.get_env(:votr, Votr.JWT)
  @key @config[:key]
  @exp_sec @config[:exp_sec]

  def expires_in() do
    @exp_sec
  end

  def generate(subject_id) do
    now = DateTime.utc_now()
          |> DateTime.to_unix()
    JsonWebToken.sign(
      %{
        sub: HashId.encode(subject_id),
        iat: now,
        nbf: now,
        exp: now + @exp_sec
      },
      %{key: @key}
    )
  end

  def verify(nil) do
    {:error, :invalid}
  end

  def verify(jwt) do
    case JsonWebToken.verify(jwt, %{key: @key}) do
      {:ok, claims} ->
        now = DateTime.utc_now()
              |> DateTime.to_unix()

        cond do
          now > claims.exp ->
            {:error, :expired}
          now > (claims.iat + @exp_sec) ->
            {:error, :expired}
          true ->
            {:ok, claims.sub}
        end
      {:error, :invalid} ->
        {:error, :invalid}
    end
  end

end
