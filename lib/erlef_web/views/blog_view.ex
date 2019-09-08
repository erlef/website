defmodule ErlefWeb.BlogView do
  use ErlefWeb, :view

  def byline(post) do
    month = Timex.month_name(post.datetime.month)
    day = post.datetime.day
    year = post.datetime.year
    author = post.author

    "#{month} #{day}, #{year} by #{author}"
  end

  def category(nil), do: "Uncategorized"
  def category(%{name: name}), do: name
end
