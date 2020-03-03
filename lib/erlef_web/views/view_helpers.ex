defmodule ErlefWeb.ViewHelpers do
  @moduledoc "View Helpers"

  def long_date(nil), do: ""

  def long_date(%DateTime{} = datetime),
    do: Timex.format!(datetime, "%B %d, %Y", :strftime)

  def long_date(other), do: other

  def event_dates(%Date{} = start_date, nil),
    do: Timex.format!(start_date, "%B %d, %Y", :strftime)

  def event_dates(%Date{} = start_date, %Date{} = end_date) do
    {:ok, year} = Timex.format(start_date, "%Y", :strftime)
    {:ok, start_date} = Timex.format(start_date, "%B %d", :strftime)
    {:ok, end_date} = Timex.format(end_date, "%B %d", :strftime)

    "#{start_date} - #{end_date}, #{year}"
  end

  def event_dates(start_date, end_date),
    do: "#{start_date} - #{end_date}"
end
