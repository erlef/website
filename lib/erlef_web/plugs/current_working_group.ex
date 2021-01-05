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
        assign(conn, :current_working_group, wg)

      {:error, :not_found} ->
        conn
        |> Phoenix.Controller.redirect(to: "/")
        |> Plug.Conn.halt()
    end
  end
end
