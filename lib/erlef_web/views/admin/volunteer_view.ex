defmodule ErlefWeb.Admin.VolunteerView do
  use ErlefWeb, :view

  def image_path(_conn, <<"http", _rest::binary>> = url), do: url
  def image_path(conn, path), do: Routes.static_path(conn, "/images/#{path}")
end
