defmodule ErlefWeb.ViewHelpers do
  @moduledoc "View Helpers"

  def author_name("eef"), do: "ErlEF"

  def author_name(name), do: name

  def blog_tag_name("eef"), do: "announcements"
  def blog_tag_name(name), do: name

  def active_sponsors([]), do: []
  def active_sponsors(sponsors), do: Enum.filter(sponsors, &(not &1.is_founding_sponsor))

  def founding_sponsors([]), do: []
  def founding_sponsors(sponsors), do: Enum.filter(sponsors, & &1.is_founding_sponsor)

  def long_date(nil), do: ""

  def long_date(%DateTime{} = datetime),
    do: Timex.format!(datetime, "%B %d, %Y", :strftime)

  def long_date(other), do: other

  def current_path_segment(conn) do
    [current | _] =
      conn
      |> path_info()
      |> Enum.reverse()

    current
  end

  def path_info(conn) do
    URI.decode_query(conn.request_path) |> Map.keys() |> hd |> String.split("/", trim: true)
  end

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
