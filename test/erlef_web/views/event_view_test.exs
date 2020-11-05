defmodule ErlefWeb.EventViewTest do
  use ExUnit.Case

  alias ErlefWeb.EventView, as: Helper

  describe "active_class/2" do
    test "returns `active` if the selected and the link type are the same" do
      assert "active" = Helper.active_class("conference", "conference")
    end

    test "returns an empty string if the selected is different from the link type" do
      assert "" = Helper.active_class("conference", "meetup")
    end
  end
end
