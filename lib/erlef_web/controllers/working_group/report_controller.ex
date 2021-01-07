defmodule ErlefWeb.WorkingGroup.ReportController do
  use ErlefWeb, :controller

  alias Erlef.Groups
  alias Erlef.Groups.WorkingGroupReport
  require Logger

  def new(conn, _params) do
    wg = conn.assigns.current_working_group
    changeset = Groups.change_working_group_report(%WorkingGroupReport{})
    render(conn, "new.html", changeset: changeset, working_group: wg)
  end

  def create(conn, %{"working_group_report" => params}) do
    wg = conn.assigns.current_working_group

    case Groups.create_working_group_report(with_default_params(conn, params)) do
      {:ok, _working_group_report} ->
        conn
        |> put_flash(:info, "Working group report created successfully.")
        |> redirect(to: Routes.working_group_path(conn, :show, wg.slug))

      {:error, %Ecto.Changeset{} = changeset} ->
        render(conn, "new.html", changeset: changeset, working_group: wg)

      err ->
        Logger.error(fn -> "Error creating working group report : #{inspect(err)}" end)

        conn
        |> put_flash(:error, "Unknown error while attempting to create working group report")
        |> redirect(to: Routes.working_group_report_path(conn, :new, wg.slug))
    end
  end

  defp with_default_params(conn, %{"file" => %Plug.Upload{} = file} = params) do
    params =
      params
      |> Map.delete("file")
      |> Map.put("content", File.read!(file.path))

    with_default_params(conn, params)
  end

  defp with_default_params(conn, params) do
    default = %{
      "working_group_id" => conn.assigns.current_working_group.id,
      "submitted_by_id" => conn.assigns.current_volunteer.id
    }

    Map.merge(params, default)
  end
end
