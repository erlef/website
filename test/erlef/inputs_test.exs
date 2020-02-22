defmodule Erlef.InputsTest do
  use ExUnit.Case, async: true

  describe "is_email/1" do
    test "when total length is valid" do
      assert true == Erlef.Inputs.is_email("starbelly@foo.eh")
      good = String.duplicate("e", 64) <> "@" <> String.duplicate("e", 185) <> ".com"
      assert true == Erlef.Inputs.is_email(good)
    end

    test "when total local part is too long" do
      bad = String.duplicate("e", 65) <> "@bar.org"
      assert false == Erlef.Inputs.is_email(bad)
    end

    test "when total domain part is too long" do
      bad = "e@" <> String.duplicate("e", 187) <> ".com"
      assert false == Erlef.Inputs.is_email(bad)
    end
  end
end
