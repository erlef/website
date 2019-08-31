defmodule ErlefWeb.EventView do
  use ErlefWeb, :view

  def year_month_day(date) do
    {:ok, dt, _offset} = DateTime.from_iso8601(date)
    "#{dt.year}-#{dt.month}-#{dt.day}"
  end

  def at_date(event) do
    meta = event.metadata
    {:ok, dt1, _offset} = DateTime.from_iso8601(meta["start"])
    {:ok, dt2, _offset} = DateTime.from_iso8601(meta["end"])
    month = Timex.month_name(dt1.month)
    day = dt1.day
    {:ok, start} = Timex.format(dt1, "%T", :strftime)
    {:ok, ends} = Timex.format(dt2, "%T", :strftime)
    "#{month} #{day} @ #{start} - #{ends}"
  end

  def month_name_and_day(event) do
    meta = event.metadata
    {:ok, dt1, _offset} = DateTime.from_iso8601(meta["start"])
    month = Timex.month_name(dt1.month)
    day = dt1.day
    "#{month} #{day}"
  end

  def time_duration(event) do
    meta = event.metadata
    {:ok, dt1, _offset} = DateTime.from_iso8601(meta["start"])
    {:ok, dt2, _offset} = DateTime.from_iso8601(meta["end"])
    {:ok, start} = Timex.format(dt1, "%T", :strftime)
    {:ok, ends} = Timex.format(dt2, "%T", :strftime)
    "#{start} - #{ends}"
  end
end
