defmodule Mix.Tasks.Eef.Gen.Event do
  use Mix.Task
  import Mix.Generator

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
        file = Path.join(root_path(), "#{format_datetime(datetime)}_#{slug}.md")

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

        file

      _ ->
        Mix.raise(
          "expected eef.gen.event to receive event slug, " <>
            "got: #{inspect(Enum.join(args, " "))}"
        )
    end
  end

  defp root_path do
    case Erlef.is_env?(:test) do
      true -> "priv/test/events"
      false -> "priv/events"
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
    "datetime": "<%= DateTime.to_iso8601(@datetime) %>",
    "title": "<%= @title %>",
    "slug": "<%= @slug %>",
    "start": "<%= DateTime.to_iso8601(@start_date) %>",
    "end": "<%= DateTime.to_iso8601(@end_date) %>",
    "offset": "UTC offset",
    "gcal_url", "https://gcal-event-template-url.changeme",
    "gmap_embed_url": "https://gmap-embed-url.changeme",
    "organizer": "Organizer Name",
    "organizer_url": "https://organizer-url.changeme",
    "venue_name": "Venue name",
    "venue_address1": "Venue Address1",
    "venue_address2": "Venue Address2",
    "venue_address3": "Venue Address3",
    "venue_territory": "Venue state/province/region",
    "venue_postal_code": "12345",
    "venue_country":  "Venue country",
    "venue_url": "https://venue_url.changeme",
    "venue_gmap_url": "https://venue_gmap_url.changeme",
  }
  ---
  Event excerpt goes here
  ---
  Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Varius sit amet mattis vulputate enim nulla aliquet. Purus in massa tempor nec feugiat. Enim lobortis scelerisque fermentum dui faucibus in ornare. In nulla posuere sollicitudin aliquam ultrices sagittis orci.
  """)
end
