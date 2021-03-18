defmodule Erlef.Admins.Notifications do
  @moduledoc false

  import Swoosh.Email

  @type notification_type() :: :new_email_request | :new_slack_invite

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

  def new(:new_slack_invite, %{member: member}) do
    msg = """
    A member has requested access to the Erlef slack. 

    Please type `/invite`, hit, then enter the members's email : #{member.email}

    Then click done :tada:
    """

    if Erlef.is_env?(:prod) do
      Erlef.SlackInvite.send_to_erlef_slack_invite_channel(msg)
    end
  end
end
