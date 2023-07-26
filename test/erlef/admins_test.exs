defmodule Erlef.AdminsTest do
  use Erlef.DataCase

  alias Erlef.Admins

  test "resource_counts/0" do
    exp = %{
      volunteers_count: 0,
      working_groups_count: 0,
      sponsors_count: 0,
      unapproved_events_count: 0,
      outstanding_email_requests_count: 0,
      apps_count: 0,
      academic_papers_count: 0,
      unapproved_academic_papers_count: 0
    }

    assert exp == Admins.resource_counts()
  end
end
