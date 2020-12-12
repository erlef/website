defmodule Erlef.Community.LanguagesTest do
  use ExUnit.Case, async: true

  describe "all/0" do
    languages = Erlef.Community.Resources.all_languages()
    assert Enum.count(languages) == 17
  end
end
