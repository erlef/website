defmodule Erlef.Jobs.URIType do
  @moduledoc false

  use Ecto.Type

  def type(), do: :string

  def cast(uri) when is_binary(uri) do
    case URI.parse(uri) do
      %URI{scheme: nil} ->
        {:error, message: "is missing a scheme (e.g. https)"}

      %URI{host: nil} ->
        {:error, message: "is missing a host"}

      %URI{host: host} = uri ->
        case :inet.gethostbyname(String.to_charlist(host)) do
          {:ok, _} -> {:ok, uri}
          {:error, _} -> {:error, message: "has an invalid host"}
        end
    end
  end

  def cast(%URI{} = uri), do: {:ok, uri}

  def load(uri), do: {:ok, URI.parse(uri)}

  def dump(%URI{} = uri), do: {:ok, URI.to_string(uri)}

  def dump(_), do: :error
end

defimpl Phoenix.HTML.Safe, for: URI do
  def to_iodata(data), do: Phoenix.HTML.Engine.html_escape(URI.to_string(data))
end
