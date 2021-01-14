defmodule ErlefWeb.Admin.SponsorController do
  use ErlefWeb, :controller

  alias Erlef.Groups
  alias Erlef.Groups.Sponsor

  def index(conn, _params) do
    sponsors = Groups.list_sponsors()
    render(conn, "index.html", sponsors: sponsors)
  end

  def new(conn, _params) do
    changeset = Groups.change_sponsor(%Sponsor{})
    render(conn, "new.html", changeset: changeset)
  end

  def create(conn, %{"sponsor" => sponsor_params}) do
    case Groups.create_sponsor(sponsor_params, audit: audit(conn)) do
      {:ok, sponsor} ->
        conn
        |> put_flash(:info, "Sponsor created successfully.")
        |> redirect(to: Routes.admin_sponsor_path(conn, :show, sponsor))

      {:error, %Ecto.Changeset{} = changeset} ->
        render(conn, "new.html", changeset: changeset)
    end
  end

  def show(conn, %{"id" => id}) do
    sponsor = Groups.get_sponsor!(id)
    render(conn, "show.html", sponsor: sponsor)
  end

  def edit(conn, %{"id" => id}) do
    sponsor = Groups.get_sponsor!(id)
    changeset = Groups.change_sponsor(sponsor)
    render(conn, "edit.html", sponsor: sponsor, changeset: changeset)
  end

  def update(conn, %{"id" => id, "sponsor" => sponsor_params}) do
    sponsor = Groups.get_sponsor!(id)

    case Groups.update_sponsor(sponsor, sponsor_params, audit: audit(conn)) do
      {:ok, sponsor} ->
        conn
        |> put_flash(:info, "Sponsor updated successfully.")
        |> redirect(to: Routes.admin_sponsor_path(conn, :show, sponsor))

      {:error, %Ecto.Changeset{} = changeset} ->
        render(conn, "edit.html", sponsor: sponsor, changeset: changeset)
    end
  end
end
