defmodule Erlef.CommunityTest do
  use ExUnit.Case, async: true

  describe "all/0" do
    test "languages" do
      community_map = Erlef.Community.all()

      assert Map.has_key?(community_map, :languages)

      expected_langs = [
        "Bragful",
        "Caramel",
        "Clojerl",
        "Cuneiform",
        "Elchemy",
        "Elixir",
        "Erlang",
        "Erlog",
        "Fika",
        "Gleam",
        "Hamler",
        "Joxa",
        "LFE (Lisp Flavored Erlang)",
        "Luerl",
        "OTPCL",
        "Purerl",
        "Rufus"
      ]

      langs =
        community_map.languages
        |> Enum.map(& &1.name)
        |> Enum.sort()

      assert langs == expected_langs
    end
  end
end
