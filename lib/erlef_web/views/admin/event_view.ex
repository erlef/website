defmodule ErlefWeb.Admin.EventView do
  use ErlefWeb, :view
  import ErlefWeb.ViewHelpers, only: [event_dates: 2]

  def title(_), do: "Events"
end
