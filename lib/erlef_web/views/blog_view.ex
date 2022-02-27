defmodule ErlefWeb.BlogView do
  use ErlefWeb, :view

  def posted_in(%{category: cat}, nil) when cat in ["eef", "newsletter"] do
    assigns = %{}
    ~H"""
    Posted in <a href="/news">News</a>
    """
  end

  def posted_in(post, wg) do
    assigns = %{post: "/wg/" <> post, wg: wg}
    ~H"""
    Posted in <a href={@post}><%= @wg.name %></a>
    """
  end

  def byline(post) do
    month = Calendar.strftime(post.datetime, "%B")
    day = post.datetime.day
    year = post.datetime.year
    author = author_name(post.authors)

    "#{month} #{day}, #{year} by #{author}"
  end
end
