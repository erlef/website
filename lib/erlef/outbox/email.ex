defmodule Erlef.Outbox.Email do
  @moduledoc """
  A generalized Oban worker for sending emails.
  """

  use Oban.Worker, queue: :email

  alias Erlef.Mailer

  @impl Oban.Worker
  def perform(%Oban.Job{args: %{"module" => m, "fun" => f, "args" => args}}) do
    module = String.to_existing_atom(m)
    function = String.to_existing_atom(f)

    module
    |> apply(function, args)
    |> Mailer.deliver()
  end
end
