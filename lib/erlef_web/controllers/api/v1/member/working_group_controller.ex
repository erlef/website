defmodule ErlefWeb.API.V1.Member.WorkingGroupController do
  use ErlefWeb, :controller

  alias Erlef.Groups
  alias Erlef.Groups.Volunteer

  action_fallback ErlefWeb.FallbackController

  def index(conn, %{"id" => member_id}) do
    render_groups(conn, member_id)
  end

  defp render_groups(conn, member_id) do
    case Groups.get_volunteer_by_member_id(member_id) do
      %Volunteer{} = v ->
        json(conn, %{data: collect_groups_for_volunteer(v)})

      _ ->
        conn
        |> put_status(404)
        |> json(%{data: []})
    end
  end

  defp collect_groups_for_volunteer(v) do
    Enum.map(v.working_groups, fn wg ->
      is_chair = Groups.is_chair?(wg, v)
      %{name: wg.name, slug: wg.slug, is_chair: is_chair}
    end)
  end
end
