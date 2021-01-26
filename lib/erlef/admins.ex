defmodule Erlef.Admins do
  @moduledoc false

  alias Erlef.Admins.Notifications
  alias Erlef.Mailer

  def notify(type, params \\ %{}) do
    type
    |> Notifications.new(params)
    |> Mailer.deliver()
  end

  def resource_counts() do
    q = """
    select 
    (select count(id) from volunteers), 
    (select count(id) from working_groups), 
    (select count(id) from sponsors),
    (select count(id) from events where events.approved = false), 
    (select count(id) from member_email_requests where member_email_requests.status != 'complete'),
    (select count(id) from apps)
    """

    %{
      rows: [
        [
          volunteer_count,
          working_group_count,
          sponsors_count,
          unapproved_events_count,
          outstanding_email_requests_count,
          apps_count
        ]
      ]
    } = Ecto.Adapters.SQL.query!(Erlef.Repo, q)

    %{
      volunteers_count: volunteer_count,
      working_groups_count: working_group_count,
      sponsors_count: sponsors_count,
      unapproved_events_count: unapproved_events_count,
      outstanding_email_requests_count: outstanding_email_requests_count,
      apps_count: apps_count
    }
  end
end
