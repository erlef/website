defmodule ErlefWeb.Plug.Authz.AbleToPost do
  @moduledoc false

  import Plug.Conn

  alias Erlef.Blog

  def init(opts), do: opts

  def call(conn, _opts) do
    case Blog.categories_allowed_to_post(conn.assigns.current_user) do
      [] ->
        conn
        |> Phoenix.Controller.redirect(to: "/")
        |> halt()

      categories ->
        assign(conn, :categories, categories)
    end
  end
end
