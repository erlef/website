defmodule Erlef.Agenda.Parser do
  @moduledoc false

  # n.b., This module (at this time) makes no attempt to validate ICS contents and as such
  # the results of the combination (at least currently) can not be guaranteed
  # to be valid. Rather, it depends on well formed ICS inputs

  @doc """
  Given a list of ics strings, where each string is an ics file in its entirety, this function combines
  all ics vevents and and vtimezones into a single ics string. All other calendar objects are ignored. 
  """
  @spec combine([String.t()]) :: String.t()
  def combine(cals, opts \\ []) do
    cals
    |> Enum.map(&split_and_trim/1)
    |> Enum.flat_map(&get_events_and_timezones/1)
    |> Enum.flat_map(fn x -> x end)
    |> Enum.reverse()
    |> Enum.join("\n")
    |> wrap(opts)
  end

  defp split_and_trim(ics_str) do 
    Enum.map(String.split(ics_str, "\n"), fn s -> s end)
  end

  defp wrap(body, opts) do
    name = Keyword.get(opts, :name, "Erlef Calendar")

    """
    BEGIN:VCALENDAR
    VERSION:2.0
    CALSCALE:GREGORIAN
    METHOD:PUBLISH
    PRODID:-//Erlef/1.0/EN
    X-WR-CALNAME:#{name}
    #{body}
    END:VCALENDAR
    """
  end

  defp get_events_and_timezones(lines), do: get_events_and_timezones(lines, [])

  defp get_events_and_timezones([], acc), do: acc

  defp get_events_and_timezones([<<"BEGIN:VTIMEZONE\r">> = line | lines], acc) do
    {lines, timezone} = collect_timezone(lines, [line])
    get_events_and_timezones(lines, [timezone | acc])
  end

  defp get_events_and_timezones([<<"BEGIN:VEVENT\r">> = line | lines], acc) do
    {lines, event} = collect_event(lines, [line])
    get_events_and_timezones(lines, [event | acc])
  end

  defp get_events_and_timezones([_ | lines], acc), do: get_events_and_timezones(lines, acc)

  defp collect_event([<<"END:VEVENT\r">> = line | lines], acc), do: {lines, [line | acc]}

  defp collect_event([line | lines], acc), do: collect_event(lines, [line | acc])

  defp collect_timezone([<<"END:VTIMEZONE\r">> = line | lines], acc), do: {lines, [line | acc]}

  defp collect_timezone([line | lines], acc), do: collect_timezone(lines, [line | acc])
end
