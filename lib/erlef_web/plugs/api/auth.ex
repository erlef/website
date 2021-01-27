defmodule ErlefWeb.Plug.API.Auth do
  @moduledoc false

  import Plug.Conn

  alias Erlef.Integrations

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
      [] ->
        try_basic(conn)

      [key] ->
        case app_key_auth(String.trim(key), conn) do
          :ok -> true
          _ -> false
        end
    end
  end

  defp try_basic(conn) do
    case Plug.BasicAuth.parse_basic_auth(conn) do
      {app_client_id, key} ->
        verify_basic(app_client_id, key, conn)

      _ ->
        false
    end
  end

  # Note : only webhook api keys are valid in this execution path
  defp verify_basic(app_client_id, key, conn) do
    case app_key_auth(app_client_id, key, conn) do
      :ok -> true
      _ -> false
    end
  end

  defp app_key_auth(key, conn) do
    case Integrations.Auth.by_key(key, :api_read_only, usage_info(conn)) do
      :ok -> :ok
      :error -> {:error, :key}
      :revoked -> {:error, :revoked_key}
    end
  end

  defp app_key_auth(app_client_id, key, conn) do
    case Integrations.Auth.by_key(app_client_id, key, :webhook, usage_info(conn)) do
      :ok -> :ok
      :error -> {:error, :key}
      :revoked -> {:error, :revoked_key}
    end
  end

  defp usage_info(%{remote_ip: remote_ip} = conn) do
    %{
      ip: remote_ip,
      used_at: DateTime.utc_now(),
      user_agent: get_req_header(conn, "user-agent")
    }
  end
end
