defmodule Erlef.InputsTest do
  use ExUnit.Case, async: true
  doctest Erlef.Inputs

  describe "is_email?/1" do
    test "when total length is valid" do
      assert Erlef.Inputs.is_email?("starbelly@foo.eh")
      good = String.duplicate("e", 64) <> "@" <> String.duplicate("e", 185) <> ".com"
      assert Erlef.Inputs.is_email?(good)
    end

    test "when total local part is too long" do
      bad = String.duplicate("e", 65) <> "@bar.org"
      refute Erlef.Inputs.is_email?(bad)
    end

    test "when total domain part is too long" do
      bad = "e@" <> String.duplicate("e", 187) <> ".com"
      refute Erlef.Inputs.is_email?(bad)
    end
  end

  describe "is_url?/1" do
    test "when the string has a schema, host, and path" do
      assert Erlef.Inputs.is_url?("https://foo.bar/")
      assert Erlef.Inputs.is_url?("https://foo.bar/some/path")
      assert Erlef.Inputs.is_url?("https://foo.bar/some/path?p=param")
    end

    test "when the string does not have a path" do
      refute Erlef.Inputs.is_url?("https://foo.bar")
    end

    test "when the string does not have a scheme" do
      refute Erlef.Inputs.is_url?("foo.bar/")
    end

    test "when the string does not have a host" do
      refute Erlef.Inputs.is_url?("https:///foo")
    end
  end
end
