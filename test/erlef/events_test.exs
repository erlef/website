defmodule Erlef.EventsTest do
  use Erlef.DataCase

  alias Erlef.Events
  alias Erlef.Schema.Event

  test "event_types/0" do
    insert(:event_type, %{name: "meetup"})
    assert [[{:key, "meetup"}, {:value, _}]] = Events.event_types()
  end

  test "submit/1" do
    type = insert(:event_type, %{name: "meetup"})
    p = params_for(:event, %{event_type_id: type.id})
    assert {:ok, %Event{}} = Events.submit(p)
  end

  test "approve/2" do
    type = insert(:event_type, %{name: "meetup"})
    p = params_for(:event, %{event_type_id: type.id})
    cs = Event.submission_changeset(%Event{}, p)
    event = Repo.insert!(cs)

    assert {:ok, %Event{approved_by: 12345}} =
             Events.approve(event.id, %{approved_by: 12345, approved_at: DateTime.utc_now()})
  end

  test "format_error/1" do
    exp =
      "The event organization logo you attempted to upload is not supported. Supported formats : jpg, png"

    assert exp == Events.format_error({:error, :unsupported_org_file_type})

    assert "An unknown error ocurred" == Events.format_error(:anything_else)
  end

  test "new_event/0" do
    assert %Ecto.Changeset{} = Events.new_event()
  end

  test "new_event/1" do
    assert %Ecto.Changeset{} = Events.new_event(%{})
  end
end
