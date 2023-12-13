defmodule Erlef.Admins.Notifications do
  @moduledoc false

  import Swoosh.Email

  @type notification_type() ::
          :new_email_request | :new_event_submitted | :new_slack_invite | :new_job_post_submitted

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

  def new(:new_event_submitted, _) do
    msg = """
    A new event was submitted. Visit https://erlef.org/admin/ to view unapproved events.
    """

    new()
    |> to({"Website Admins", "infra@erlef.org"})
    |> from({"Erlef Notifications", "notifications@erlef.org"})
    |> subject("A new event was submitted")
    |> text_body(msg)
  end

  def new_job_post_submission() do
    msg = """
    A new job post was submitted. Visit https://erlef.org/admin/ to view unapproved events.
    """

    new()
    |> to({"Website Admins", "infra@erlef.org"})
    |> from({"Erlef Notifications", "notifications@erlef.org"})
    |> subject("A new job post was successfully submitted.")
    |> text_body(msg)
  end
end
