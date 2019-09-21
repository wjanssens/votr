defmodule Votr.Api.Fixture do

  alias Votr.Identity.Subject
  alias Votr.Identity.Controls
  alias Votr.Election.Ward
  alias Votr.Election.Ballot
  alias Votr.JWT

  def with_subject(f, email \\ 'test@example.com') do
    with {:ok, subject} = Subject.insert(email),
         {:ok, _} = Controls.insert(%Controls{subject_id: subject.id, failures: 0}) do
      f.(subject, JWT.generate(subject.id))
    end
  end

  def with_ward(subject_id, f) do
    with {:ok, ward} = Ward.insert(subject_id, %{seq: 0}) do
      f.(ward)
    end
  end

  def with_ballot(subject_id, ward_id, f) do
    with {:ok, ballot} = Ballot.insert(
           subject_id,
           %{ward_id: ward_id, seq: 0, method: "scottish_stv", quota: "droop"}
         ) do
      f.(ballot)
    end
  end

end
