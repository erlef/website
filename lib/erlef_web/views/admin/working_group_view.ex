defmodule ErlefWeb.Admin.WorkingGroupView do
  use ErlefWeb, :view

  def title(%{assigns: %{working_group: wg}}) do
    "#{wg.name} Working Group"
  end

  def title(_), do: "Working Groups"
end
