defmodule ErlefWeb.Admin.UnapprovedAcademicPaperView do
  use ErlefWeb, :view

  def title(_), do: "Unapproved Academic papers"

  def get_date(changeset), do: changeset.data.original_publish_date

  def year(nil), do: nil

  def year(date) do
    Map.get(date, :year)
  end

  def month(nil), do: nil

  def month(date) do
    Map.get(date, :month)
  end

  def day(nil), do: nil

  def day(date) do
    Map.get(date, :day)
  end
end
