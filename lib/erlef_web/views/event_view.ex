defmodule ErlefWeb.EventView do
  use ErlefWeb, :view

  def year_month_day(date) do
    {:ok, dt, _offset} = DateTime.from_iso8601(date)
    "#{dt.year}-#{dt.month}-#{dt.day}"
  end

  def at_date(date_str) do
    {:ok, dt1, _offset} = DateTime.from_iso8601(date_str)
    month = Timex.month_name(dt1.month)
    day = dt1.day
    {:ok, start} = Timex.format(dt1, "%T", :strftime)
    "#{month} #{day} @ #{start}"
  end

  def month_name_and_day(date_str) do
    {:ok, dt, _offset} = DateTime.from_iso8601(date_str)
    month = Timex.month_name(dt.month)
    day = dt.day
    "#{month} #{day}"
  end

  def time(date_str, "UTC" <> offset) when offset != "" do
    {offset_hours, _offset_minutes_str} = Integer.parse(offset)
    {:ok, datetime, _offset} = DateTime.from_iso8601(date_str)

    datetime
    |> Timex.shift(hours: offset_hours)
    |> format_time
  end

  def time(date_str, _), do: time(date_str)

  def time(date_str) when is_binary(date_str) do
    {:ok, dt, _offset} = DateTime.from_iso8601(date_str)
    format_time(dt)
  end

  def time(%DateTime{} = datetime), do: format_time(datetime)

  def gcal_id(nil), do: ""
  def gcal_id(id), do: "data-gcal-id=#{id} "

  def gcal_api_key(nil), do: ""
  def gcal_api_key(key), do: "data-gcal-api-key=#{key} "

  defp format_time(datetime) do
    {:ok, time} = Timex.format(datetime, "%T", :strftime)
    time
  end
end
