defmodule ErlefWeb.BlogView do
  use ErlefWeb, :view

  def as_html(txt) do
    txt
    |> HtmlSanitizeEx.strip_tags()
    |> Earmark.as_html!()
    |> raw()
  end

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
    month = Calendar.strftime(post.inserted_at, "%B")
    day = post.inserted_at.day
    year = post.inserted_at.year
    author = author_name(post.authors)

    "#{month} #{day}, #{year} by #{author}"
  end

  def allowed_to_edit?(assigns, post) do
    post.category in Erlef.Blog.categories_allowed_to_post(assigns.current_user)
  end

  def authors_value(form) do
    case form.params do
      %{"authors" => authors} when is_bitstring(authors) ->
        Enum.join(form.params["authors"], ", ")

      _ ->
        Enum.join(form.data.authors, ", ")
    end
  end

  def tags_value(form) do
    case form.params do
      %{"tags" => tags} when is_bitstring(tags) ->
        Enum.join(form.params["tags"], ", ")

      _ ->
        Enum.join(form.data.tags, ", ")
    end
  end
end
