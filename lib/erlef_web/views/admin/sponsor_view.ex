defmodule ErlefWeb.Admin.SponsorView do
  use ErlefWeb, :view

  def title(%{assigns: %{sponsor: sponsor}}) do
    "Sponsor - #{sponsor.name}"
  end

  def title(_), do: "Sponsors"
end
