defmodule ErlefWeb.ViewHelpers do
  @moduledoc "View Helpers"

  def long_date(nil), do: ""

  def long_date(%DateTime{} = datetime),
    do: Timex.format!(datetime, "%B %d, %Y", :strftime)

  def long_date(other), do: other
end
