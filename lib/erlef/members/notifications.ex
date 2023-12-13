defmodule Erlef.Members.Notifications do
  @moduledoc false

  alias Erlef.Accounts
  alias Erlef.Accounts.Member

  import Swoosh.Email

  @type notification_type() ::
          :new_event_submitted | :new_event_approved | :new_job_post_submitted

  @type params() :: map()

  def new(:new_event_submitted, %{member: member}) do
    msg = """
    Thanks for submitting a new event, we appreciate your involvement in our community. 
    An admin will approve the event for display shortly. Once approved you will get an email stating so. 

    In the event you haven't seen an approval in 48 hours please send an email to web_admin@erlef.org.

    Thanks

    The Erlang Ecosystem Foundation
    """

    new()
    |> to({member.name, member.email})
    |> from({"Erlef Notifications", "notifications@erlef.org"})
    |> subject("You submitted a new event")
    |> text_body(msg)
  end

  def new(:new_event_approved, %{member: member}) do
    msg = """
    An event you submitted has been approved and is now published on the site.

    Once again, we appreciate your involvement with our community and hope to see more event submissions
    from you in the future! 

    Thanks

    The Erlang Ecosystem Foundation
    """

    new()
    |> to({member.name, member.email})
    |> from({"Erlef Notifications", "notifications@erlef.org"})
    |> subject("Your submitted event has been approved!")
    |> text_body(msg)
  end

  def new_job_post_submission(member_id) do
    %Member{name: name, email: email} = Accounts.get_member!(member_id)

    msg = """
    Thanks for submitting a new event, we appreciate your involvement in our community.
    An admin will approve the event for display shortly. Once approved you will get an email stating so.

    Thanks

    The Erlang Ecosystem Foundation
    """

    new()
    |> to({name, email})
    |> from({"Erlef Notifications", "notifications@erlef.org"})
    |> subject("Your submitted a new job post")
    |> text_body(msg)
  end

  def job_post_approval(member_id, post_title) do
    %Member{name: name, email: email} = Accounts.get_member!(member_id)

    msg = """
    Your job post "#{post_title}" has been approved by an administrator.

    The Erlang Ecosystem Foundation
    """

    new()
    |> to({name, email})
    |> from({"Erlef Notifications", "notifications@erlef.org"})
    |> subject("Your submitted a new job post")
    |> text_body(msg)
  end
end
