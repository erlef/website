defmodule ErlefWeb.AboutController do
  use ErlefWeb, :controller

  action_fallback ErlefWeb.FallbackController

  def show(conn, %{"topic" => "working-groups"}), do: render(conn, "working_groups.html")

end
