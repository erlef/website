defmodule ErlefWeb.Plug.CurrentWorkingGroup do
  @moduledoc """
  ErlefWeb.Plug.CurrentWorkingGroup - Gets and assigns the current working group to the conn.
  Redirects to / if it can't be found.
  """

  import Plug.Conn

  alias Erlef.Groups

  def init(opts), do: opts

  def call(%{path_params: %{"slug" => wg_slug}} = conn, _opts) do
    case Groups.get_working_group_by_slug(wg_slug) do
      {:ok, wg} ->
        conn
        |> assign(:current_working_group, wg)
        |> assign(:is_volunteer, is_volunteer(conn, wg))
        |> assign(:is_chair, is_chair(conn, wg))

      {:error, :not_found} ->
        conn
        |> Phoenix.Controller.redirect(to: "/")
        |> Plug.Conn.halt()
    end
  end

  defp is_volunteer(%{assigns: %{current_user: member}}, wg) do
    Groups.is_volunteer?(wg, member)
  end

  defp is_chair(%{assigns: %{current_user: member}}, wg) do
    Groups.is_chair?(wg, member)
  end
end
