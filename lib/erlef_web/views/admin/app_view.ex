defmodule ErlefWeb.Admin.AppView do
  use ErlefWeb, :view

  def title(%{assigns: %{app: app}}) do
    "App #{app.name}"
  end

  def title(_), do: "Apps"

  defp app_settings(conn, app) do
    [
      apps: {"General", Routes.admin_app_path(conn, :show, app.slug), "fas fa-cogs"},
      keys: {"Keys", Routes.admin_app_key_path(conn, :index, app.slug), "fas fa-key"}
    ]
  end

  defp selected_setting(conn, id) do
    id_str = Atom.to_string(id)

    case Enum.take(path_info(conn), -3) do
      ["admin", ^id_str, _] -> "active sidebar-selected"
      ["apps", _, ^id_str] -> "active sidebar-selected"
      _ -> ""
    end
  end
end
