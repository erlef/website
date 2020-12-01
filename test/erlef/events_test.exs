defmodule Erlef.EventsTest do
  use Erlef.DataCase

  alias Erlef.Events

  test "event_types/0" do
    #    [_ | _] = Events.event_types()
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
