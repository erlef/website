defmodule ErlefWeb.Admin.VolunteerController do
  use ErlefWeb, :controller

  alias Erlef.Groups
  alias Erlef.Groups.Volunteer

  def index(conn, _params) do
    volunteers = Groups.list_volunteers()
    render(conn, "index.html", volunteers: volunteers)
  end

  def new(conn, _params) do
    changeset = Groups.change_volunteer(%Volunteer{})
    render(conn, "new.html", changeset: changeset)
  end

  def create(conn, %{"volunteer" => volunteer_params}) do
    case Groups.create_volunteer(volunteer_params, audit: audit(conn)) do
      {:ok, volunteer} ->
        conn
        |> put_flash(:info, "volunteer created successfully.")
        |> redirect(to: Routes.admin_volunteer_path(conn, :show, volunteer))

      {:error, %Ecto.Changeset{} = changeset} ->
        render(conn, "new.html", changeset: changeset)
    end
  end

  def show(conn, %{"id" => id}) do
    volunteer = Groups.get_volunteer!(id)
    render(conn, "show.html", volunteer: volunteer)
  end

  def edit(conn, %{"id" => id}) do
    volunteer = Groups.get_volunteer!(id)
    changeset = Groups.change_volunteer(volunteer)
    render(conn, "edit.html", volunteer: volunteer, changeset: changeset)
  end

  def update(conn, %{"id" => id, "volunteer" => volunteer_params}) do
    volunteer = Groups.get_volunteer!(id)

    case Groups.update_volunteer(volunteer, volunteer_params, audit: audit(conn)) do
      {:ok, volunteer} ->
        conn
        |> put_flash(:info, "volunteer updated successfully.")
        |> redirect(to: Routes.admin_volunteer_path(conn, :show, volunteer))

      {:error, %Ecto.Changeset{} = changeset} ->
        render(conn, "edit.html", volunteer: volunteer, changeset: changeset)
    end
  end

  def delete(conn, %{"id" => id}) do
    volunteer = Groups.get_volunteer!(id)
    {:ok, _volunteer} = Groups.delete_volunteer(volunteer)

    conn
    |> put_flash(:info, "volunteer deleted successfully.")
    |> redirect(to: Routes.admin_volunteer_path(conn, :index))
  end
end
