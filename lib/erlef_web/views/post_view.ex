defmodule ErlefWeb.PostView do
  use ErlefWeb, :view

  def posted_in(%{category: cat}, nil) when cat in ["eef", "newsletter"] do
    """
    Posted in <a href="/news">News</a>
    """
  end

  def posted_in(%{category: cat} = _post, wg) do
    assigns = %{cat_path: "/wg/#{cat}", wg: wg}

    ~H"""
    Posted in <a href={@cat_path}><%= wg.name %></a>
    """
  end

  def byline(post) do
    month = Calendar.strftime(post.updated_at, "%B")
    day = post.updated_at.day
    year = post.updated_at.year
    author = author_name(["post.author"])

    "#{month} #{day}, #{year} by #{author}"
  end
end
