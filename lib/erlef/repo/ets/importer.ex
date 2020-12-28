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
    migrate_working_groups()
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

  defp import_resources(resource) do
    Enum.each(files_to_changesets(resource), fn set ->
      {:ok, _inserted} = Erlef.Repo.ETS.insert(set)
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

  alias Erlef.Groups.WorkingGroup
  alias Erlef.Groups.Volunteer
  alias Erlef.Groups.WorkingGroupVolunteer
  alias Erlef.Repo

  def migrate_working_groups do
    path = "/working_groups/**/*.md"

    for set <- Enum.map(find_files(path), &parse_wg_post/1) do
      volunteers =
        for v <- set.volunteers do
          {maybe_insert_volunteer(v), v}
        end

      wg = maybe_insert_wg(set.working_group)

      for {v, v_data} <- volunteers do
        maybe_add_volunteer_to_wg(wg, v, v_data["is_chair"])
      end
    end
  end

  defp maybe_insert_wg(wg) do
    case Repo.get_by(WorkingGroup, name: wg["name"]) do
      %WorkingGroup{} = group ->
        group

      _ ->
        cs = WorkingGroup.changeset(%WorkingGroup{}, wg)
        Repo.insert!(cs)
    end
  end

  defp maybe_insert_volunteer(v) do
    case Repo.get_by(Volunteer, name: v["name"]) do
      %Volunteer{} = vol ->
        vol

      _ ->
        cs = Volunteer.changeset(%Volunteer{}, Map.put(v, "avatar_url", v["image"]))
        Repo.insert!(cs)
    end
  end

  defp maybe_add_volunteer_to_wg(wg, vol, is_chair) do
    case Repo.get_by(WorkingGroupVolunteer, volunteer_id: vol.id, working_group_id: wg.id) do
      %WorkingGroupVolunteer{} = wgv ->
        wgv

      _ ->
        p = %{volunteer_id: vol.id, working_group_id: wg.id, is_chair: is_chair}
        cs = WorkingGroupVolunteer.changeset(%WorkingGroupVolunteer{}, p)
        Repo.insert!(cs)
    end
  end

  defp parse_wg_post(file) do
    post_str = File.read!(file)
    trimmed_str = String.trim_leading(post_str)

    case String.split(trimmed_str, ~r/[\s\r\n]---[\s\r\n]/s, parts: 3) do
      [front, _excerpt, body] ->
        compile_wg({front, body})

      [front, body] ->
        compile_wg({front, body})
    end
  end

  defp compile_wg({front_str, body_str}) do
    {:ok, data0} = Jason.decode(front_str)

    back = %{
      "proposal" => body_str
    }

    {meta, _data1} = Map.split(data0, ["email", "gcal_url", "github"])

    {volunteers, wg} = Map.split(data0, ["volunteers"])

    wg = Map.put(Map.merge(wg, back), "meta", meta)
    %{working_group: wg, volunteers: volunteers["volunteers"]}
  end

  defp find_files(wildcard) do
    priv_dir = :code.priv_dir(:erlef) |> :erlang.list_to_binary()
    Path.wildcard(priv_dir <> wildcard)
  end
end
