defmodule Erlef.Members.Notifications do
  @moduledoc false

  import Swoosh.Email

  @type notification_type() :: :new_event_submitted | :new_event_approved

  @type params() :: map()

  def new(:new_event_submitted, %{member: member}) do
    msg = """
    Thanks for submitting a new event, we appreciate your involvment in our community. 
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
    |> from({member.name, member.email})
    |> subject("Your submitted event has been approved!")
    |> text_body(msg)
  end
end
