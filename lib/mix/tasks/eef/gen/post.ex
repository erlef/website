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
    switches = [author: :string, title: :string]
    aliases = [a: :author, t: :title]

    case OptionParser.parse(args, switches: switches, aliases: aliases) do
      {options, [blog, slug], _invalid} ->
        title = Keyword.get(options, :title, "Title")
        author = Keyword.get(options, :author, "Author")
        datetime = DateTime.utc_now()
        path = root_path(blog)
        file = Path.join(path, "#{format_datetime(datetime)}_#{slug}.md")

        create_file(
          file,
          post_template(title: title, slug: slug, datetime: datetime, author: author)
        )

      _ ->
        Mix.raise(
          "expected eef.gen.post to receive blog slug, " <>
            "got: #{inspect(Enum.join(args, " "))}"
        )
    end
  end

  defp root_path(blog) do
    repo = Erlef.Blogs.Config.repo_for(blog)
    Path.relative_to(repo.root, Mix.Project.app_path())
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

  embed_template(:post, """
  {
    "title": "<%= @title %>",
    "author": "<%= @author %>",
    "slug": "<%= @slug %>",
    "datetime": "<%= DateTime.to_iso8601(@datetime) %>"
  }
  ---
  Post excerpt goes here
  ---
  Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Varius sit amet mattis vulputate enim nulla aliquet. Purus in massa tempor nec feugiat. Enim lobortis scelerisque fermentum dui faucibus in ornare. In nulla posuere sollicitudin aliquam ultrices sagittis orci.
  """)
end
