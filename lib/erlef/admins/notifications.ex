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

    A workspace owner or admin must now go on the Erlef slack workspace and create
    an invite for the member by typing the following : 

    /invite 

    And then enter the members's email : #{member.email}

    Note: You may be prompted to approve this invitation as well.
    """

    new()
    |> to({"Erlef Slack Invites", "erlef-slack-invites@erlef.org"})
    |> from({"Erlef Notifications", "notifications@erlef.org"})
    |> subject("A member is requesting a new slack invite")
    |> text_body(msg)
  end
end
