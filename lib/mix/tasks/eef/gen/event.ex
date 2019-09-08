defmodule Mix.Tasks.Eef.Gen.Event do
  use Mix.Task
  import Mix.Generator
  alias Erlef.Events.Repo

  @shortdoc "Generates an event post"

  @moduledoc """
  Generates an event post.

  ## Example

      mix eef.gen.event slug --title "best event ever"

  ## Command line options

  * `-t`, `--title` - title of the event post [optional]
  """

  @doc false
  def run(args) do
    switches = [title: :string]
    aliases = [t: :title]

    case OptionParser.parse(args, switches: switches, aliases: aliases) do
      {options, [slug], _invalid} ->
        title = Keyword.get(options, :title, "Title goes here")
        datetime = DateTime.utc_now()
        path = Repo.root()
        file = Path.join(path, "#{format_datetime(datetime)}_#{slug}.md")

        create_file(
          file,
          event_template(
            start_date: DateTime.utc_now(),
            end_date: DateTime.utc_now(),
            title: title,
            slug: slug,
            datetime: datetime
          )
        )

      _ ->
        Mix.raise(
          "expected eef.gen.event to receive event slug, " <>
            "got: #{inspect(Enum.join(args, " "))}"
        )
    end
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

  embed_template(:event, """
  {
    "title": "<%= @title %>",
    "slug": "<%= @slug %>",
    "start": "<%= DateTime.to_iso8601(@start_date) %>",
    "end": "<%= DateTime.to_iso8601(@end_date) %>",
    "datetime": "<%= DateTime.to_iso8601(@datetime) %>",
    "event_url": "https://gcal_url.changeme",
    "gmap_embed_url": "https://gmap_embed_url.changeme",
    "organizer": "Organize Name",
    "organizer_url": "https://organize_url.changeme",
    "venue_url": "https://venue_url.changeme",
    "venue_territory": "Venue state/territory/province",
    "venue_country": "Venue Two letter Country Code",
    "venue_gmap_url": "https://venue_gmap_url.changeme",
    "venue_address1": "123 Mocking Bird Lane",
    "venue_address2": "Building 42",
    "venue_country":  "Venue country code"
  }
  ---
  Event excerpt goes here
  ---
  Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Varius sit amet mattis vulputate enim nulla aliquet. Purus in massa tempor nec feugiat. Enim lobortis scelerisque fermentum dui faucibus in ornare. In nulla posuere sollicitudin aliquam ultrices sagittis orci.
  """)
end
