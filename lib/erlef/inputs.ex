defmodule Erlef.Inputs do
  @moduledoc """
  Erlef.Inputs provides re-useable input validations
  """

  @doc ~S"""
  Validates an email address.

  Specifically, this function checks that the overall size of the email address and its parts
  are of the right byte size per [RFC 2822](https://tools.ietf.org/html/rfc2822#section-3.4.1)

  ## Examples

      iex> Erlef.Inputs.is_email?("foo@bar.org")
      true
      iex> Erlef.Inputs.is_email?("eh?")
      false

  """
  def is_email?(addr) when byte_size(addr) <= 254 do
    case :binary.split(addr, "@") do
      [local, domain] when byte_size(local) <= 64 and byte_size(domain) <= 190 ->
        case :binary.split(domain, ".") do
          [_part1, _part2 | _rest] -> true
          _ -> false
        end

      _ ->
        false
    end
  end

  def is_email?(_), do: false

  @doc ~S"""
    Validates a URL. Erlef considers a valid url to consist of :

      - a scheme (e.g., http://, ftp://, gopher://)
      - a host (e.g., erlef.org)
      - a path (e.g., /wg)

    A path must always be present even if it's simply `/`.

    ## Examples

      iex> Erlef.Inputs.is_url?("https://erlef.org/")
      true
      iex> Erlef.Inputs.is_url?("https://erlef.org")
      false
      iex> Erlef.Inputs.is_url?("erlef.org")
      false

  """

  def is_url?(uri) do
    case :uri_string.parse(uri) do
      %{scheme: ""} ->
        false

      %{host: ""} ->
        false

      %{path: ""} ->
        false

      %{scheme: _schema, host: _host, path: _path} ->
        true

      _ ->
        false
    end
  end
end
