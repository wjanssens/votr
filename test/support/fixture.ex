defmodule Votr.Api.Fixture do

  alias Votr.Identity.Subject
  alias Votr.Identity.Controls
  alias Votr.JWT

  def with_subject(f, email \\ 'test@example.com') do
    {:ok, subject} = Subject.insert(email)
    {:ok, _} = Controls.insert(%Controls{subject_id: subject.id, failures: 0})
    f.(JWT.generate(subject.id))
  end
end
