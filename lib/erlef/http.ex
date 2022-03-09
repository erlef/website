defmodule Erlef.HTTP do
  @moduledoc """
  Erlef.HTTP - Lightweight wrapper around hackney with a few json encoding/decoding conveniences
  """

  @success_range 200..299
  @json_mimes ["application/json", "application/json; charset=utf-8", "application/vnd.api+json"]

  def perform(method, url, headers, body, opts) do
    trusted_headers = safe_headers(headers)
    {:ok, payload} = maybe_json_encode(content_type(trusted_headers), body)

    case :hackney.request(method, url, trusted_headers, payload, build_options(opts)) do
      {:ok, status_code, res_headers, client_ref} ->
        pretty_result(method, url, headers, status_code, res_headers, client_ref)

      err ->
        err
    end
  end

  defp pretty_result(method, url, req_headers, status_code, headers, client) do
    {:ok, body} = :hackney.body(client)

    {:ok, res_body} = maybe_json_decode(content_type(headers), body)

    result = %{
      body: res_body,
      headers: headers,
      req_headers: req_headers,
      url: url,
      method: method,
      status: status_code
    }

    case is_success(status_code) do
      true ->
        map = result |> Map.merge(%{status: status_code})
        {:ok, map}

      _ ->
        {:error, result}
    end
  end

  defp safe_headers(headers) do
    Enum.map(headers, fn {k, v} ->
      {URI.encode(k), safe_header_value(v)}
    end)
  end

  defp safe_header_value(v) do
    v
    |> String.split(" ")
    |> Enum.map_join(" ", &URI.encode/1)
  end

  defp content_type(headers) do
    headers = :hackney_headers.new(headers)

    case :hackney_headers.get_value("content-type", headers) do
      [h | _] -> h
      str -> str
    end
  end

  defp maybe_json_encode(type, body) when type in @json_mimes do
    Jason.encode(body)
  end

  defp maybe_json_encode(_headers, body), do: {:ok, body}

  defp maybe_json_decode(type, body) when type in @json_mimes do
    Jason.decode(body)
  end

  defp maybe_json_decode(_headers, body), do: {:ok, body}

  defp build_options(params) do
    [{:pool, :default}] ++ params
  end

  defp is_success(status) do
    status in @success_range
  end
end
