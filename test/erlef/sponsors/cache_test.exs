defmodule Erlef.Sponsors.CacheTest do
  use ExUnit.Case, async: true

  alias Erlef.Sponsors.Cache

  @valid_sponsor %{
    "name" => "Example Sponsor",
    "url" => "https://example.com/",
    "logo_url" => "https://sponsor.erlef.org/assets/images/sponsors/example.svg",
    "impact" => "strategic",
    "note" => nil
  }

  @normalized_sponsor %{
    name: "Example Sponsor",
    url: "https://example.com/",
    logo_url: "https://sponsor.erlef.org/assets/images/sponsors/example.svg",
    impact: "strategic",
    note: nil
  }

  test "accepts a version 1 sponsor payload" do
    assert {:ok, [@normalized_sponsor]} =
             Cache.sponsors_from_payload(%{"version" => 1, "sponsors" => [@valid_sponsor]})
  end

  test "rejects unsupported versions and malformed sponsors" do
    assert {:error, :invalid_payload} =
             Cache.sponsors_from_payload(%{"version" => 2, "sponsors" => []})

    assert {:error, :invalid_sponsor} =
             Cache.sponsors_from_payload(%{
               "version" => 1,
               "sponsors" => [%{"name" => "Missing fields"}]
             })
  end

  @tag :capture_log
  test "stores valid refreshes and retains stale data after a failed refresh" do
    cache_key = {__MODULE__, make_ref()}
    test_pid = self()
    on_exit(fn -> :persistent_term.erase(cache_key) end)
    attempts = start_supervised!({Agent, fn -> 0 end})

    fetcher = fn "endpoint" ->
      case Agent.get_and_update(attempts, fn count -> {count, count + 1} end) do
        0 ->
          send(test_pid, :fetched)
          {:ok, %{"version" => 1, "sponsors" => [@valid_sponsor]}}

        _ ->
          send(test_pid, :failed)
          {:error, :unavailable}
      end
    end

    pid =
      start_supervised!(
        {Cache,
         name: nil,
         cache_key: cache_key,
         endpoint: "endpoint",
         fetcher: fetcher,
         refresh_interval: :timer.hours(24)}
      )

    assert_receive :fetched
    :sys.get_state(pid)
    assert :persistent_term.get(cache_key) == [@normalized_sponsor]

    send(pid, :refresh)
    assert_receive :failed
    :sys.get_state(pid)
    assert :persistent_term.get(cache_key) == [@normalized_sponsor]
  end
end
