defmodule ErlefWeb.Plug.Authz.Volunteer do
  @moduledoc """
  ErlefWeb.Plug.AuthzVolunteer - Redirects a conn unless the user is an volunteer. 
  Depends on ErlefWeb.Plugs.Session to be called prior. 
  """

  import Plug.Conn
  alias Erlef.Groups.Volunteer

  def init(opts), do: opts

  def call(%{assigns: %{current_volunteer: %Volunteer{}}} = conn, _opts), do: conn
  def call(conn, _opts), do: do_redirect(conn)

  defp do_redirect(conn) do
    conn
    |> Phoenix.Controller.redirect(to: "/")
    |> halt()
  end
end
