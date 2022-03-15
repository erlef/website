defmodule Erlef.CommunityTest do
  use Erlef.DataCase

  alias Erlef.Community
  alias Erlef.Community.Event
  import Swoosh.TestAssertions

  test "event_types/0" do
    assert [:conference, :training, :meetup, :hackathon] = Community.event_types()
  end

  test "submit/1" do
    logo = %Plug.Upload{
      path: "assets/static/images/android-icon-36x36.png",
      filename: "android-icon-36x36.png"
    }

    p = string_params_for(:event, type: :hackathon)
    member = insert_member!("basic_member")
    p = Map.merge(p, %{"organizer_brand_logo" => logo, "submitted_by_id" => member.id})
    assert {:ok, %Event{}} = Community.submit_event(p, %{member: member})
    assert_email_sent(Erlef.Admins.Notifications.new(:new_event_submitted, %{}))
    assert_email_sent(Erlef.Members.Notifications.new(:new_event_submitted, %{member: member}))
  end

  test "approve/2" do
    member = insert_member!("basic_member")
    p = params_for(:event, %{submitted_by_id: member.id, type: :meetup})
    cs = Event.submission_changeset(%Event{}, p)
    event = Repo.insert!(cs)

    event = Community.get_event(event.id)
    assert Community.unapproved_events_count() == 1
    assert [%Event{}] = Community.unapproved_events()

    admin = insert_member!("admin")

    assert {:ok, %Event{}} =
             Community.approve_event(event.id, %{
               approved_by_id: admin.id,
               approved_at: DateTime.utc_now()
             })

    assert Community.unapproved_events_count() == 0
    assert [] = Community.unapproved_events()
    assert [%Event{}] = Community.approved_events()
    assert_email_sent(Erlef.Members.Notifications.new(:new_event_approved, %{member: member}))
  end

  test "get_event/1" do
    member = insert_member!("basic_member")
    p = params_for(:event, %{submitted_by_id: member.id, type: :training})
    cs = Event.submission_changeset(%Event{}, p)
    event = Repo.insert!(cs)

    fetched_event = Community.get_event(event.id)
    assert fetched_event.id == event.id
  end

  test "format_error/1" do
    exp =
      "The event organization logo you attempted to upload is not supported. Supported formats : jpg, png"

    assert exp == Community.format_error({:error, :unsupported_org_file_type})

    assert "An unknown error occurred" == Community.format_error(:anything_else)
  end

  test "new_event/0" do
    assert %Ecto.Changeset{} = Community.new_event()
  end

  test "new_event/1" do
    assert %Ecto.Changeset{} = Community.new_event(%{})
  end

  describe "all_resources/0" do
    test "languages" do
      community_map = Erlef.Community.all_resources()

      assert Map.has_key?(community_map, :languages)

      expected_langs = [
        "Bragful",
        "Caramel",
        "Clojerl",
        "Cuneiform",
        "Elchemy",
        "Elixir",
        "Erlang",
        "Erlog",
        "Fika",
        "Gleam",
        "Hamler",
        "LFE (Lisp Flavored Erlang)",
        "Luerl",
        "OTPCL",
        "Purerl",
        "Rufus"
      ]

      langs =
        community_map.languages
        |> Enum.map(& &1.name)
        |> Enum.sort()

      assert langs == expected_langs
    end
  end
end
