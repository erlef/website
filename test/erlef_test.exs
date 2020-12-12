defmodule Erlef.EnvTest do
  use ExUnit.Case, async: true

  test "in_env?/1" do
    assert Erlef.in_env?([:test, :dev])
    refute Erlef.in_env?([:dev, :prod])
  end

  test "is_env?/1" do
    assert Erlef.is_env?(:test)
    refute Erlef.is_env?(:dev)
  end

  test "data_path/1" do
    assert Erlef.data_path("community/languages.exs") ==
             Path.absname("_build/test/lib/erlef/priv/data/community/languages.exs")
  end

  test "get_data/1" do
    assert [%{} | _] = Erlef.get_data("community/languages.exs")
  end
end
