defmodule Erlef.Agenda.ParserTest do
  use ExUnit.Case, async: true

  alias Erlef.Agenda.Parser

  test "combine/1" do
    assert ics = Parser.combine(all_calendars())
    assert <<"BEGIN:VCALENDAR\n", _::binary>> = ics
  end

  defp all_calendars() do
    Enum.map(Path.wildcard(Path.absname("test/support/data/ics/*.ics")), fn path ->
      File.read!(path)
    end)
  end
end
