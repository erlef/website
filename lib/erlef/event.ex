defmodule Erlef.Event do
  defstruct title: "",
            slug: "",
            description: "",
            start: "",
            end: "",
            backgroundColor: "",
            textColor: "",
            allDay: false

  @priv_dir "priv/events/*.md"

  @type t :: map()

  @spec all :: [t]
  def all do
    priv_dir()
    |> Path.wildcard()
    |> Enum.map(&load!/1)
  end

  def list do
    priv_dir()
    |> Path.wildcard()
    |> Enum.map(&as_json/1)
  end

  @spec fetch(String.t()) :: t | nil
  def fetch(slug) do
    all()
    |> Enum.find(&slug_matches?(&1, slug))
  end

  defp priv_dir, do: @priv_dir

  defp load!(path) do
    path
    |> File.read!()
    |> to_map()
    |> compile()
  end

  defp as_json(path) do
    path
    |> File.read!()
    |> to_map()
  end

  defp to_map(str) do
    Jason.decode!(str)
  end

  defp slug_matches?(%{slug: slug}, slug), do: true
  defp slug_matches?(_working_group, _slug), do: false

  defp compile(attrs) do
    %__MODULE__{
      title: attrs["title"],
      slug: attrs["slug"],
      description: attrs["description"],
      start: parse_date(attrs, "start"),
      end: parse_date(attrs, "end"),
      backgroundColor: attrs["backgroundColor"],
      textColor: attrs["textColor"],
      allDay: attrs["allDay"]
    }
  end

  defp parse_date(attrs, key) do
    {:ok, dt, _} =
      attrs
      |> Map.fetch!(key)
      |> IO.inspect()
      |> DateTime.from_iso8601()

    dt
  end
end
