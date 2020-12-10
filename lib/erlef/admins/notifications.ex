defmodule Erlef.Admins.Notifications do
  @moduledoc false

  import Swoosh.Email

  @type notification_type() :: :new_email_request

  @type params() :: map()

  @spec new(notification_type(), params()) :: Swoosh.Email.t()
  def new(:new_email_request, _) do
    msg = """
    A new email request was created. Visit https://erlef.org/admin/ to view outstanding requests.
    """

    new()
    |> to({"Infrastructure Requests", "infra.requests@erlef.org"})
    |> from({"Erlef Notifications", "notifications@erlef.org"})
    |> subject("A new email request was created")
    |> text_body(msg)
  end
end
