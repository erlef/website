defmodule Erlef.Community.AffiliatesTest do
  use ExUnit.Case, async: true

  describe "all/0" do
    affiliates = Erlef.Community.Affiliates.all_affiliates()
    assert Enum.count(affiliates) == 3
  end
end
