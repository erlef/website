defmodule Erlef.WG do
  defstruct name: "", slug: "", description: "", email: "", formed: nil

  @priv_dir "priv/working_groups/*md"

  @type t :: map()

  @spec all :: [t]
  def all do
    priv_dir()
    |> Path.wildcard()
    |> Enum.map(&load!/1)
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

  defp to_map(str) do
    str
    |> String.split("\n")
    |> Enum.reject(&(&1 == ""))
    |> Enum.map(&String.split(&1, ": "))
    |> Map.new(&List.to_tuple/1)
  end

  defp slug_matches?(%{slug: slug}, slug), do: true
  defp slug_matches?(_working_group, _slug), do: false

  defp compile(attrs) do
    %__MODULE__{
      name: attrs["name"],
      slug: attrs["slug"],
      description: attrs["description"],
      email: attrs["email"],
      formed: parse_date(attrs, "formed")
    }
  end

  defp parse_date(attrs, key) do
    attrs
    |> Map.fetch!(key)
    |> Date.from_iso8601!()
  end
end
