defmodule ErlefWeb.EventView do
  use ErlefWeb, :view

  def year_month_day(dt) do
    "#{dt.year}-#{dt.month}-#{dt.day}"
  end

  def at_date(dt1) do
    month = Timex.month_name(dt1.month)
    day = dt1.day
    {:ok, start} = Timex.format(dt1, "%T", :strftime)
    "#{month} #{day} @ #{start}"
  end

  def month_name_and_day(dt) do
    month = Timex.month_name(dt.month)
    day = dt.day
    "#{month} #{day}"
  end

  def time(datetime, "UTC" <> offset) when offset != "" do
    {offset_hours, _offset_minutes_str} = Integer.parse(offset)

    datetime
    |> Timex.shift(hours: offset_hours)
    |> format_time
  end

  def time(date, _), do: time(date)

  def time(%DateTime{} = datetime), do: format_time(datetime)

  def gcal_id(nil), do: ""
  def gcal_id(id), do: "data-gcal-id=#{id}"

  def gcal_api_key(nil), do: ""
  def gcal_api_key(key), do: "data-gcal-api-key=#{key}"

  defp format_time(datetime) do
    {:ok, time} = Timex.format(datetime, "%T", :strftime)
    time
  end
end
