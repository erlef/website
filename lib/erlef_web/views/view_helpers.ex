defmodule ErlefWeb.ViewHelpers do
  @moduledoc "View Helpers"

  def author_name(["eef"]), do: "ErlEF"

  def author_name([name]), do: name

  def author_name(names), do: Enum.join(names, ", ")

  def blog_tag_name("eef"), do: "announcements"
  def blog_tag_name(name), do: name

  def active_sponsors([]), do: []

  def active_sponsors(sponsors) do
    sponsors
    |> Enum.filter(& &1.active)
    |> Enum.shuffle()
  end

  def active_and_founding_sponsors([]), do: []

  def active_and_founding_sponsors(sponsors) do
    sponsors
    |> Enum.filter(&(&1.active and &1.is_founding_sponsor))
    |> Enum.shuffle()
  end

  def active_non_founding_sponsors([]), do: []

  def active_non_founding_sponsors(sponsors) do
    sponsors
    |> Enum.filter(&(&1.active and not &1.is_founding_sponsor))
    |> Enum.shuffle()
  end

  def founding_non_active_sponsors([]), do: []

  def founding_non_active_sponsors(sponsors) do
    sponsors
    |> Enum.filter(&(not &1.active and &1.is_founding_sponsor))
    |> Enum.shuffle()
  end

  def founding_sponsors([]), do: []

  def founding_sponsors(sponsors) do
    sponsors
    |> Enum.filter(& &1.is_founding_sponsor)
    |> Enum.shuffle()
  end

  def long_date(nil), do: ""

  def long_date(%DateTime{} = datetime),
    do: Calendar.strftime(datetime, "%B %d, %Y")

  def long_date(other), do: other

  def long_date_time(nil), do: ""

  def long_date_time(%DateTime{} = datetime),
    do: Calendar.strftime(datetime, "%c")

  def long_date_time(other), do: other

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
    do: Calendar.strftime(start_date, "%B %d, %Y")

  def event_dates(%Date{} = start_date, %Date{} = end_date) do
    year = Calendar.strftime(start_date, "%Y")
    start_date = Calendar.strftime(start_date, "%B %d")
    end_date = Calendar.strftime(end_date, "%B %d")
    "#{start_date} - #{end_date}, #{year}"
  end

  def event_dates(start_date, end_date),
    do: "#{start_date} - #{end_date}"

  def render_shared(template, assigns \\ []) do
    Phoenix.View.render(ErlefWeb.SharedView, template, assigns)
  end

  def logged_in?(assigns) do
    !!assigns[:current_user]
  end

  def image_path(_conn, nil), do: ""

  def image_path(_conn, <<"http", _rest::binary>> = url), do: url

  def image_path(conn, <<"volunteers", _rest::binary>> = path) do
    ErlefWeb.Router.Helpers.static_path(conn, "/images/" <> path)
  end

  def image_path(conn, path), do: ErlefWeb.Router.Helpers.static_path(conn, path)

  def event_organizer_logo(nil), do: "/images/default_event_icon.svg"
  def event_organizer_logo(logo_path), do: logo_path

  def event_organizer_color(nil), do: "#efefef"
  def event_organizer_color(color), do: color
end
