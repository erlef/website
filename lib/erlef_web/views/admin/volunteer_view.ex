defmodule ErlefWeb.Admin.VolunteerView do
  use ErlefWeb, :view

  def title(%{assigns: %{volunteer: vol}}) do
    "Volunteer - #{vol.name}"
  end

  def title(_), do: "Volunteers"
end
