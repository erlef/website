defmodule ErlefWeb.ViewHelpersTest do
  use ExUnit.Case

  alias ErlefWeb.ViewHelpers, as: Helper

  describe "long_date/1" do
    test "returns a long formated date from a %DateTime{}" do
      {_, datetime, _} = DateTime.from_iso8601("1971-11-25T23:50:07Z")

      assert "November 25, 1971" = Helper.long_date(datetime)
    end

    test "returns the value when arg is NOT a %DateTime{}" do
      assert "Publication date‎: ‎November 25, 1971" =
               Helper.long_date("Publication date‎: ‎November 25, 1971")
    end

    test "returns empty string from a nil" do
      assert "" = Helper.long_date(nil)
    end
  end
end
