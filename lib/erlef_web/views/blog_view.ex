defmodule ErlefWeb.BlogView do
  use ErlefWeb, :view

  def posted_in(%{category: cat}, nil) when cat in ["eef", "newsletter"] do
    ~E"""
    Posted in <a href="/news">News</a>
    """
  end

  def posted_in(post, wg) do
    ~E"""
    Posted in <a href="/wg/<%= post.category %>"><%= wg.name %></a>
    """
  end

  def byline(post) do
    month = Calendar.strftime(post.datetime, "%B")
    day = post.datetime.day
    year = post.datetime.year
    author = author_name(post.author)

    "#{month} #{day}, #{year} by #{author}"
  end
end
