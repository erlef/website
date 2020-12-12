defmodule Erlef.FellowsTest do
  use ExUnit.Case, async: true

  alias Erlef.Fellows

  test "all/0" do
    assert [%{} | _] = Fellows.all()
  end
end
