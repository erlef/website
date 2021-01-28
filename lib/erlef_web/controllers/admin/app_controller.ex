defmodule ErlefWeb.Admin.AppController do
  use ErlefWeb, :controller

  alias Erlef.Integrations
  alias Erlef.Integrations.{App, AppKey}

  def index(conn, _params) do
    apps = Integrations.list_apps()
    render(conn, "index.html", apps: apps)
  end

  def new(conn, _params) do
    changeset = App.changeset(%App{}, %{})
    render(conn, "new.html", changeset: changeset)
  end

  def create(conn, %{"app" => app_params}) do
    case Integrations.create_app(app_params, audit: audit(conn)) do
      {:ok, app} ->
        conn
        |> put_flash(:info, "App created successfully.")
        |> redirect(to: Routes.admin_app_path(conn, :show, app.slug))

      {:error, %Ecto.Changeset{} = changeset} ->
        render(conn, "new.html", changeset: changeset)
    end
  end

  def show(conn, %{"slug" => slug}) do
    app = Integrations.get_app_by_slug!(slug)
    render(conn, "show.html", app: app, key_changeset: AppKey.changeset(%AppKey{}, %{}))
  end

  def edit(conn, %{"slug" => slug}) do
    app = Integrations.get_app_by_slug!(slug)
    changeset = App.changeset(app, %{})
    render(conn, "edit.html", app: app, changeset: changeset)
  end

  def update(conn, %{"slug" => slug, "app" => app_params}) do
    app = Integrations.get_app_by_slug!(slug)

    case Integrations.update_app(app, app_params, audit: audit(conn)) do
      {:ok, app} ->
        conn
        |> put_flash(:info, "App updated successfully.")
        |> redirect(to: Routes.admin_app_path(conn, :show, app.slug))

      {:error, %Ecto.Changeset{} = changeset} ->
        render(conn, "edit.html", app: app, changeset: changeset)
    end
  end
end
