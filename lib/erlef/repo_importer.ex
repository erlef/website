defmodule Erlef.Repo.Importer do
  @moduledoc """
    Erlef.Repo.Importer - handles importing markdown files into the ETS repo
  """

  use GenServer

  @post_pattern ~r/[\s\r\n]---[\s\r\n]/s

  def start_link([]) do
    GenServer.start_link(__MODULE__, [])
  end

  @impl true
  def init(_args) do
    {:ok, {}, {:continue, :compile}}
  end

  @impl true
  def handle_continue(:compile, {}) do
    :ok = do_imports()
    repo_ref = monitor_repo()
    {:noreply, {repo_ref}}
  end

  @impl true
  def handle_info({:DOWN, _ref, :process, _pid, _reason}, {monitor_ref}) do
    Process.demonitor(monitor_ref)
    :ok = do_imports()
    new_ref = monitor_repo()
    {:noreply, {new_ref}}
  end

  ### Private

  def do_imports do
    imports = Application.get_env(:erlef, :repo_imports)
    Enum.each(imports, &import_resources/1)
    :ok
  end

  defp monitor_repo do
    repo_pid = Process.whereis(Erlef.Repo)
    Process.monitor(repo_pid)
  end

  defp import_resources(resource) do
    Enum.each(files_to_changesets(resource), fn set ->
      {:ok, _inserted} = Erlef.Repo.insert(set)
    end)
  end

  @map_keys %{
    "body_html" => "description",
    "excerpt_html" => "excerpt",
    "event_url" => "url",
    "gmap_embed_url" => "venue_gmap_embed_url"
  }
  defp files_to_changesets({path, Erlef.Data.Event}) do
    Enum.map(find_files(path), fn f ->
      params =
        Enum.reduce(@map_keys, parse_post(f), fn {k, v}, acc ->
          Map.put_new(acc, v, acc[k])
        end)

      params2 = Map.merge(params, %{"submitted_by" => 0, "approved_by" => 0})

      Erlef.Data.Event.changeset(struct(Erlef.Data.Event), params2)
    end)
  end

  defp files_to_changesets({path, schema}) do
    Enum.map(find_files(path), fn f ->
      schema.changeset(struct(schema), parse_post(f))
    end)
  end

  defp parse_post(file) do
    post_str = File.read!(file)
    trimmed_str = String.trim_leading(post_str)

    case String.split(trimmed_str, @post_pattern, parts: 3) do
      [front, excerpt, body] ->
        compile({front, excerpt, body})

      [front, body] ->
        compile({front, "", body})
    end
  end

  defp compile({front_str, excerpt_str, body_str}) do
    {:ok, front} = Jason.decode(front_str)
    {:ok, excerpt_html, _} = Earmark.as_html(excerpt_str)
    {:ok, body_html, _} = Earmark.as_html(body_str)

    back = %{
      "body" => body_str,
      "body_html" => body_html,
      "excerpt" => excerpt_str,
      "excerpt_html" => excerpt_html
    }

    Map.merge(front, back)
  end

  defp find_files(wildcard) do
    priv_dir = :code.priv_dir(:erlef) |> :erlang.list_to_binary()
    Path.wildcard(priv_dir <> wildcard)
  end
end
