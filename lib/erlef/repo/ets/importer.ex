defmodule Erlef.Repo.ETS.Importer do
  @moduledoc """
    Erlef.Repo.ETS.Importer - handles importing markdown files into the ETS repo
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
    repo_pid = Process.whereis(Erlef.Repo.ETS)
    Process.monitor(repo_pid)
  end

  defp import_resources({_, schema} = resource) do
    set = files_to_changesets(resource)

    {_, _inserted} =
      Erlef.Repo.insert_all(schema, set, conflict_target: [:slug], on_conflict: :nothing)
  end

  defp files_to_changesets({path, _schema}) do
    Enum.map(find_files(path), fn f ->
      parse_post(f)
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

    {:ok, dt, _} = DateTime.from_iso8601(front["datetime"])
    dt = DateTime.truncate(dt, :second)

    %{
      title: front["title"],
      slug: front["slug"],
      excerpt: excerpt_str,
      body: body_str,
      authors: front["authors"],
      category: front["category"],
      tags: front["tags"],
      inserted_at: dt,
      updated_at: dt,
      published_at: dt,
      status: :published
    }
  end

  defp find_files(wildcard) do
    priv_dir = :code.priv_dir(:erlef) |> :erlang.list_to_binary()
    Path.wildcard(priv_dir <> wildcard)
  end
end
