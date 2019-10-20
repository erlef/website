defmodule Erlef.EnvTest do
  use ExUnit.Case, async: true

  test "is_env?/1" do
    assert Erlef.is_env?(:test)
    refute Erlef.is_env?(:dev)
  end
end
