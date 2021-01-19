defmodule ErlefWeb.Plug.API.Auth do
  @moduledoc """
  ErlefWeb.Plug.RequiresAdmin - Redirects a conn unless the user is an admin
  """

  import Plug.Conn

  def init(opts), do: opts

  def call(conn, _opts) do
    case valid_api_key?(conn) do
      true ->
        conn

      false ->
        conn
        |> put_resp_header("content-type", "application/json")
        |> send_resp(401, Jason.encode!(%{error: "Unauthorized"}))
        |> halt()
    end
  end

  defp valid_api_key?(conn) do
    case get_req_header(conn, "x-api-key") do
      nil ->
        false

      [] ->
        false

      [key] ->
        Plug.Crypto.secure_compare(String.trim(key), Application.get_env(:erlef, :api_key))
    end
  end
end
