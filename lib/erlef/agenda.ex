defmodule Erlef.Agenda do
  @moduledoc false

  @board_ics "https://user.fm/calendar/v1-d950fe3b2598245f424e3ddbff1a674a/Board%20Public.ics"

  # 2 minutes
  @check_interval 120_000

  require Logger

  use GenServer
  alias Erlef.Agenda.Parser

  # Client
  @spec start_link(Keyword.t()) :: :ignore | {:error, term()} | {:ok, pid()}
  def start_link(opts) do
    check_interval = Keyword.get(opts, :check_interval, @check_interval)
    GenServer.start_link(__MODULE__, {sys_now(), check_interval})
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
    _tid = :ets.new(__MODULE__, ets_acl())
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

        err ->
          # credo:disable-for-lines:3
          if Erlef.in_env?([:dev, :prod]) do
            Logger.warning(fn -> "Error getting feed #{l} : #{inspect(err)}" end)
          end

          acc
      end
    end)
    |> Parser.combine(name: "ErlEF Public Calendars")
  end

  defp schedule_check({start, interval}) do
    :erlang.send_after(next_check(start, interval), self(), :check)
  end

  defp sys_now() do
    :erlang.monotonic_time(:millisecond)
  end

  defp next_check(start, interval) do
    interval - rem(sys_now() - start, interval)
  end

  defp ets_acl() do
    case Erlef.is_env?(:test) do
      true ->
        [:named_table, :public, {:write_concurrency, true}]

      false ->
        [:named_table, :protected, {:write_concurrency, true}]
    end
  end
end
