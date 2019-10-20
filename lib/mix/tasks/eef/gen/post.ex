defmodule Mix.Tasks.Eef.Gen.Post do
  use Mix.Task
  import Mix.Generator

  @shortdoc "Generates a post"
  @recursive true

  @moduledoc """
  Generates a blog post.

  ## Example

      mix eef.gen.post blog-name post-name --author someone

  ## Command line options

  * `-a`, `--author` - author of the post
  * `-t`, `--title` - title of the post
  """

  @doc false
  def run(args) do
    switches = [author: :string, title: :string, path: :string, excerpt: :string, body: :string]
    aliases = [a: :author, t: :title, p: :path, e: :excerpt, b: :body]

    case OptionParser.parse(args, switches: switches, aliases: aliases) do
      {options, [blog, slug], _invalid} ->
        title = Keyword.get(options, :title, "Title")
        author = Keyword.get(options, :author, "Author")
        datetime = DateTime.utc_now()
        path = Keyword.get(options, :path, root_path(blog))
        file = Path.join(path, "#{format_datetime(datetime)}_#{slug}.md")
        excerpt = Keyword.get(options, :excerpt, default_excerpt())
        body = Keyword.get(options, :body, default_body())

        create_file(
          file,
          post_template(
            title: title,
            slug: slug,
            datetime: datetime,
            author: author,
            category: blog,
            excerpt: excerpt,
            body: body
          )
        )

      _ ->
        Mix.raise(
          "expected eef.gen.post to receive blog slug, " <>
            "got: #{inspect(Enum.join(args, " "))}"
        )
    end
  end

  defp root_path(blog) do
    "priv/posts/#{blog}"
  end

  defp format_datetime(datetime) do
    [
      datetime.year,
      pad_string(datetime.month),
      pad_string(datetime.day),
      pad_string(datetime.hour),
      pad_string(datetime.minute),
      pad_string(datetime.second)
    ]
    |> Enum.join("")
  end

  defp pad_string(integer) do
    integer
    |> Integer.to_string()
    |> String.pad_leading(2, "0")
  end

  defp default_excerpt, do: "Post excerpt goes here"

  defp default_body,
    do:
      "Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua"

  embed_template(:post, """
  {
    "title": "<%= @title %>",
    "author": "<%= @author %>",
    "slug": "<%= @slug %>",
    "category": "<%= @category %>",
    "datetime": "<%= DateTime.to_iso8601(@datetime) %>"
  }
  ---
  <%= @excerpt %>
  ---
  <%= @body %>
  """)
end
