defmodule ErlefWeb.Admin.App.KeyController do
  use ErlefWeb, :controller

  alias Erlef.Integrations
  alias Erlef.Integrations.{App, AppKey}

  def index(conn, %{"slug" => slug}) do
    app = Integrations.get_app_by_slug!(slug)

    render(conn, "index.html",
      app: app,
      app_keys: app.keys,
      key_changeset: AppKey.changeset(%AppKey{}, %{})
    )
  end

  def create(conn, %{"slug" => slug, "app_key" => params}) do
    with %App{} = app <- Integrations.get_app_by_slug!(slug),
         {:ok, key} <- Integrations.create_app_key(app, params, audit: audit(conn)) do
      flash =
        "The key was successfully generated, " <>
          "copy the secret \"#{key.app_secret}\", you won't be able to see it again."

      conn
      |> put_flash(:info, flash)
      |> redirect(to: Routes.admin_app_key_path(conn, :index, app.slug))
    else
      _ ->
        conn
        |> put_flash(:info, "Something went wrong")
        |> redirect(to: Routes.admin_app_key_path(conn, :index, slug))
    end
  end

  def delete(conn, %{"slug" => slug, "id" => app_key_id}) do
    with %App{} = app <- Integrations.get_app_by_slug!(slug),
         %AppKey{} = app_key <- Integrations.get_app_key!(app_key_id),
         {:ok, _key} <- Integrations.revoke_app_key(app_key, audit: audit(conn)) do
      conn
      |> put_flash(:info, "The key was successfully revoked")
      |> redirect(to: Routes.admin_app_key_path(conn, :index, app.slug))
    else
      _ ->
        conn
        |> put_flash(:info, "Something went wrong")
        |> redirect(to: Routes.admin_app_key_path(conn, :index, slug))
    end
  end
end
