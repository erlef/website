defmodule ErlefWeb.Plug.RemoteAddr do
  @moduledoc false

  import Plug.Conn

  def init(opts), do: opts

  def call(conn, _opts) do
    put_private(conn, :remote_ip, remote_ip(conn))
  end

  defp remote_ip(conn) do
    case get_req_header(conn, "x-forwarded-for") do
      [] ->
        parse_ip(conn.remote_ip)

      [source] ->
        parse_ip(source)
    end
  end

  defp parse_ip(source) when is_tuple(source) do
    to_string(:inet.ntoa(source))
  end

  defp parse_ip(source) do
    case :inet.parse_strict_address(to_charlist(source)) do
      {:ok, ip} ->
        to_string(:inet.ntoa(ip))

      _ ->
        source
    end
  end
end
