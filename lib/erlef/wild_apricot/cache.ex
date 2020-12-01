defmodule Erlef.WildApricot.Cache do
  @moduledoc """
  Erlef.WildApricot.Cache is responsible for caching api tokens.

  The token is fetched at start up and refreshed every 28 minutes. 
  """

  alias Erlef.WildApricot

  # 60 seconds
  @check_interval 60_000

  use GenServer
  require Logger

  # Client
  @spec start_link(Keyword.t()) :: :ignore | {:error, term()} | {:ok, pid()}
  def start_link(_opts) do
    GenServer.start_link(__MODULE__, {sys_now(), @check_interval})
  end

  @spec get_token() :: String.t()
  def get_token() do
    case get(:token) do
      {:ok, {token, _expiry}} ->
        token

      _ ->
        {token, _expiry} = get_api_token()
        token
    end
  end

  # Server
  @impl true
  def init(opts) do
    _tid =
      :ets.new(__MODULE__, [
        :set,
        :named_table,
        :protected,
        {:read_concurrency, true},
        {:write_concurrency, false}
      ])

    {:ok, opts, {:continue, :init}}
  end

  @impl true
  def handle_continue(:init, {start, interval}) do
    token_tuple = refresh_token()
    state = maybe_refresh({start, interval, token_tuple})
    schedule_refresh_check(start, interval)
    {:noreply, state}
  end

  @impl true
  def handle_info(:refresh_token, {start, interval, _} = state) do
    state = maybe_refresh(state)
    schedule_refresh_check(start, interval)
    {:noreply, state}
  end

  # Private
  # We ran into an error initially trying to fetch the token, try again
  defp maybe_refresh({start, interval, {:error, :no_token}}) do
    token_tuple = refresh_token()
    {start, interval, token_tuple}
  end

  defp maybe_refresh({start, interval, {_token, expiry}}) when expiry <= 120 do
    token_tuple = refresh_token()
    {start, interval, token_tuple}
  end

  defp maybe_refresh({start, interval, {token, expiry}}) do
    insert_token(token, expiry - 60)
    {start, interval, {token, expiry - 60}}
  end

  defp insert_token(token, expiry) do
    :ets.insert(__MODULE__, {:token, {token, expiry}})
  end

  defp get(id), do: value(:ets.lookup(__MODULE__, id))

  defp value([{_term, found}]), do: {:ok, found}
  defp value([{_, _}, {_, _} | _]), do: {:error, :too_many_results}
  defp value([]), do: {:error, :not_found}

  defp schedule_refresh_check(start, interval) do
    :erlang.send_after(next_check(start, interval), self(), :refresh_token)
  end

  defp refresh_token() do
    case get_api_token() do
      {:error, err} ->
        log_error(err)
        {:error, :no_token}

      {token, expires_in_seconds} ->
        true = :ets.insert(__MODULE__, {:token, {token, expires_in_seconds}})
        {token, expires_in_seconds}

      err ->
        log_error(err)
        {:error, :no_token}
    end
  end

  defp log_error(err) do
    fun = fn -> "#{__MODULE__} : Error getting token from wildapricot -> #{inspect(err)}" end
    Logger.error(fun)
  end

  defp get_api_token() do
    case WildApricot.get_api_token() do
      {:ok, %{"access_token" => token, "expires_in" => expires_in_seconds}} ->
        {token, expires_in_seconds}

      err ->
        err
    end
  end

  defp sys_now() do
    :erlang.monotonic_time(:millisecond)
  end

  defp next_check(start, interval) do
    interval - rem(sys_now() - start, interval)
  end
end
