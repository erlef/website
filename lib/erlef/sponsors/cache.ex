defmodule Erlef.Sponsors.Cache do
  @moduledoc """
  Fetches and caches the current sponsors published by the sponsorship site.

  Reads use `:persistent_term` and do not call the cache process. The cache is
  refreshed asynchronously at startup and once every 24 hours. Failed refreshes
  leave the last valid value in place.
  """

  use GenServer

  require Logger

  @cache_key {__MODULE__, :current_sponsors}
  @refresh_interval :timer.hours(24)

  @type sponsor :: %{
          name: String.t(),
          url: String.t(),
          logo_url: String.t(),
          impact: String.t() | nil,
          note: String.t() | nil
        }

  @spec start_link(Keyword.t()) :: GenServer.on_start()
  def start_link(opts \\ []) do
    case Keyword.get(opts, :name, __MODULE__) do
      nil -> GenServer.start_link(__MODULE__, opts)
      name -> GenServer.start_link(__MODULE__, opts, name: name)
    end
  end

  @doc "Returns the most recently cached current sponsors."
  @spec all() :: [sponsor()]
  def all, do: :persistent_term.get(@cache_key, [])

  @impl true
  def init(opts) do
    state = %{
      cache_key: Keyword.get(opts, :cache_key, @cache_key),
      endpoint: Keyword.get(opts, :endpoint, endpoint()),
      fetcher: Keyword.get(opts, :fetcher, &fetch/1),
      refresh_interval: Keyword.get(opts, :refresh_interval, @refresh_interval)
    }

    {:ok, state, {:continue, :refresh}}
  end

  @impl true
  def handle_continue(:refresh, state) do
    {:noreply, refresh(state)}
  end

  @impl true
  def handle_info(:refresh, state) do
    {:noreply, refresh(state)}
  end

  def handle_info(_, state), do: {:noreply, state}

  defp refresh(state) do
    case state.fetcher.(state.endpoint) do
      {:ok, payload} ->
        case sponsors_from_payload(payload) do
          {:ok, sponsors} ->
            :persistent_term.put(state.cache_key, sponsors)

          {:error, reason} ->
            log_refresh_error(reason)
        end

      {:error, reason} ->
        log_refresh_error(reason)
    end

    Process.send_after(self(), :refresh, state.refresh_interval)
    state
  end

  @doc false
  @spec sponsors_from_payload(term()) :: {:ok, [sponsor()]} | {:error, term()}
  def sponsors_from_payload(%{"version" => 1, "sponsors" => sponsors})
      when is_list(sponsors) do
    if Enum.all?(sponsors, &valid_sponsor?/1) do
      {:ok, Enum.map(sponsors, &normalize_sponsor/1)}
    else
      {:error, :invalid_sponsor}
    end
  end

  def sponsors_from_payload(_), do: {:error, :invalid_payload}

  defp fetch(endpoint) do
    case Erlef.HTTP.perform(:get, endpoint, [{"accept", "application/json"}], "", []) do
      {:ok, %{status: 200, body: payload}} -> {:ok, payload}
      {:ok, %{status: status}} -> {:error, {:unexpected_status, status}}
      {:error, reason} -> {:error, reason}
    end
  end

  defp valid_sponsor?(sponsor) when is_map(sponsor) do
    non_empty_string?(sponsor["name"]) and
      non_empty_string?(sponsor["url"]) and
      non_empty_string?(sponsor["logo_url"]) and
      sponsor["impact"] in [nil, "visionary", "strategic"] and
      (is_nil(sponsor["note"]) or is_binary(sponsor["note"]))
  end

  defp valid_sponsor?(_), do: false

  defp normalize_sponsor(sponsor) do
    %{
      name: sponsor["name"],
      url: sponsor["url"],
      logo_url: sponsor["logo_url"],
      impact: sponsor["impact"],
      note: sponsor["note"]
    }
  end

  defp non_empty_string?(value), do: is_binary(value) and value != ""

  defp endpoint do
    Application.get_env(
      :erlef,
      :sponsors_endpoint,
      "https://sponsor.erlef.org/current-sponsors.json"
    )
  end

  defp log_refresh_error(reason) do
    Logger.warning("Unable to refresh current sponsors: #{inspect(reason)}")
  end
end
