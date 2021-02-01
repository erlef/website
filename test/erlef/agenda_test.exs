defmodule Erlef.AgendaTest do
  use Erlef.DataCase
  alias Erlef.Agenda

  # n.b, The following tests are merely to check :
  # - can we start up? 
  # - does the GenServer get all working group calendars and combine them and not crash?
  # - are the combined results made available?
  # - can handle_info/2 be called and not crash? 

  setup do
    # Set check interval to half a second
    wg0 =
      insert(:working_group,
        meta: %{public_calendar: "http://127.0.0.1:9998/calendars/observability.ics"}
      )

    wg1 = insert(:working_group)

    # Bad setup
    wg2 = insert(:working_group, %{meta: %{public_calendar: "http://127.0.0.1:9998/calendars"}})

    _v = insert(:working_group_volunteer, working_group: wg0)
    _v = insert(:working_group_volunteer, working_group: wg1)
    _v = insert(:working_group_volunteer, working_group: wg2)
    _c = insert(:working_group_chair, working_group: wg0)
    _c = insert(:working_group_chair, working_group: wg1)
    _c = insert(:working_group_chair, working_group: wg2)
    :ok
  end

  test "combined/0" do
    start_supervised!({Agenda, [check_interval: 500]})
    assert {:ok, <<_::binary>>} = Agenda.get_combined()
  end

  test "handle_info/0" do
    start_supervised!({Agenda, [check_interval: 500]})
    now = :erlang.monotonic_time(:millisecond)
    assert {:noreply, _} = Agenda.handle_info(:check, {now, 500})
  end
end
