defmodule ErlefWeb.Admin.App.KeyView do
  use ErlefWeb, :view

  def title(%{assigns: %{app: app, app_key: app_key}}) do
    "App #{app.name} | key #{app_key.name}"
  end

  def title(_), do: "App keys"
end
