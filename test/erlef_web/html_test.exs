defmodule ErlefWeb.HTMLTest do
  use ExUnit.Case, async: true

  alias ErlefWeb.HTML

  test "to_date_string/1" do
    dt = ~U[2020-12-13 01:18:21.114142Z]
    assert "December, 13, 2020, 01:18:21 UTC" == HTML.to_date_string(dt)
  end
end
