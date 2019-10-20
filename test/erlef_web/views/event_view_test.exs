defmodule ErlefWeb.WorkingGroupViewTest do
  use ErlefWeb.ConnCase, async: true

  test "time/2" do
    assert "00:22:22" == ErlefWeb.EventView.time(~U[1979-11-19 22:22:22.123Z], "UTC+02:00")
  end

  test "gcal_id/1" do
    assert  "" == ErlefWeb.EventView.gcal_id(nil)
    assert  "data-gcal-id=123" == ErlefWeb.EventView.gcal_id("123")
  end

  test "gcal_api_key/1" do
    assert  "" == ErlefWeb.EventView.gcal_api_key(nil)
    assert  "data-gcal-api-key=123" == ErlefWeb.EventView.gcal_api_key("123")
  end
end
