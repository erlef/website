defmodule Erlef.Agenda do
  @moduledoc false

  @board_ics "https://user.fm/calendar/v1-d950fe3b2598245f424e3ddbff1a674a/Board%20Public.ics"

  # 2 minutes
  @check_interval 120_000

  use GenServer

  # Client
  @spec start_link(Keyword.t()) :: :ignore | {:error, term()} | {:ok, pid()}
  def start_link(_opts) do
    GenServer.start_link(__MODULE__, {sys_now(), @check_interval})
  end

  @spec get_combined() :: {:ok, String.t()} | {:error, term()}
  def get_combined() do
    case :ets.lookup(__MODULE__, :all) do
      [{:all, ics}] ->
        {:ok, ics}

      [] ->
        case get_calendars() do
          ics when is_binary(ics) -> {:ok, ics}
        end
    end
  end

  # Server
  @impl true
  def init(opts) do
    {:ok, opts, {:continue, :init}}
  end

  @impl true
  def handle_continue(:init, state) do
    _tid = :ets.new(__MODULE__, [:named_table, :protected, {:write_concurrency, true}])
    :ets.insert(__MODULE__, {:all, get_calendars()})
    schedule_check(state)
    {:noreply, state}
  end

  @impl true
  def handle_info(:check, state) do
    :ets.insert(__MODULE__, {:all, get_calendars()})
    schedule_check(state)
    {:noreply, state}
  end

  def handle_info(_, state), do: {:noreply, state}

  # Private

  defp get_calendars() do
    wgs = Erlef.Groups.list_working_groups()

    wgs
    |> Enum.filter(fn wg -> not is_nil(wg.meta.public_calendar) end)
    |> Enum.map(fn wg -> wg.meta.public_calendar end)
    |> get_feeds()
  end

  defp get_feeds(links) do
    [@board_ics | links]
    |> Enum.reduce([], fn l, acc ->
      case Erlef.HTTP.perform(:get, l, [], "", []) do
        {:ok, res} ->
          [res.body | acc]

        _ ->
          acc
      end
    end)
    |> Enum.map(&split_and_trim/1)
    |> combine_all()
  end

  defp split_and_trim(ics_str),
    do: Enum.map(String.split(ics_str, "\n"), fn s -> String.trim(s) end)

  defp combine_all(cals) do
    cals
    |> Enum.flat_map(&get_events_and_timezones/1)
    |> Enum.flat_map(fn x -> x end)
    |> Enum.reverse()
    |> Enum.join("\n")
    |> wrap()
  end

  defp wrap(body) do
    """
    BEGIN:VCALENDAR
    VERSION:2.0
    CALSCALE:GREGORIAN
    METHOD:PUBLISH
    PRODID:-//Erlef/1.0/EN
    X-WR-CALNAME:ErlEF Public Calendars
    #{body}
    END:VCALENDAR
    """
  end

  defp get_events_and_timezones(lines), do: get_events_and_timezones(lines, [])

  defp get_events_and_timezones([], acc), do: acc

  defp get_events_and_timezones([<<"BEGIN:VTIMEZONE">> = line | lines], acc) do
    {lines, timezone} = collect_timezone(lines, [line])
    get_events_and_timezones(lines, [timezone | acc])
  end

  defp get_events_and_timezones([<<"BEGIN:VEVENT">> = line | lines], acc) do
    {lines, event} = collect_event(lines, [line])
    get_events_and_timezones(lines, [event | acc])
  end

  defp get_events_and_timezones([_ | lines], acc), do: get_events_and_timezones(lines, acc)

  defp collect_event([<<"END:VEVENT">> = line | lines], acc), do: {lines, [line | acc]}

  defp collect_event([line | lines], acc), do: collect_event(lines, [line | acc])

  defp collect_timezone([<<"END:VTIMEZONE">> = line | lines], acc), do: {lines, [line | acc]}

  defp collect_timezone([line | lines], acc), do: collect_timezone(lines, [line | acc])

  defp schedule_check({start, interval}) do
    :erlang.send_after(next_check(start, interval), self(), :check)
  end

  defp sys_now() do
    :erlang.monotonic_time(:millisecond)
  end

  defp next_check(start, interval) do
    interval - rem(sys_now() - start, interval)
  end
end
