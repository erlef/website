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

  def time(date_str) do
    {:ok, dt, _offset} = DateTime.from_iso8601(date_str)
    {:ok, time} = Timex.format(dt, "%T", :strftime)
    time
  end
end
