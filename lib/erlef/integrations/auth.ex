defmodule Erlef.Integrations.Auth do
  @moduledoc false

  alias Erlef.{Crypto, Integrations}
  alias Erlef.Integrations.AppKey

  def by_key(client_id, app_secret, type, usage_info) do
    our_secret = Application.get_env(:erlef, :secret)

    <<key_id::binary-size(32), secret::binary-size(32)>> =
      :crypto.mac(:hmac, :sha3_256, our_secret, app_secret)
      |> Base.encode16(case: :lower)

    with %AppKey{} = key <- Integrations.find_key(client_id, key_id, type),
         true <- Crypto.compare(key.secret, secret),
         {:revoked, false} <- {:revoked, AppKey.revoked?(key)},
         %AppKey{} <- update_last_use(key, usage_info(usage_info)) do
      :ok
    else
      {:revoked, true} ->
        :revoked

      _ ->
        :error
    end
  end

  def by_key(app_secret, type, usage_info) do
    our_secret = Application.get_env(:erlef, :secret)

    <<key_id::binary-size(32), secret::binary-size(32)>> =
      :crypto.mac(:hmac, :sha3_256, our_secret, app_secret)
      |> Base.encode16(case: :lower)

    with %AppKey{} = key <- Integrations.find_key(key_id, type),
         true <- Crypto.compare(key.secret, secret),
         {:revoked, false} <- {:revoked, AppKey.revoked?(key)},
         %AppKey{} <- update_last_use(key, usage_info(usage_info)) do
      :ok
    else
      {:revoked, true} ->
        :revoked

      _ ->
        :error
    end
  end

  defp update_last_use(key, usage_info) do
    Integrations.update_app_key_last_used(key, usage_info(usage_info))
  end

  defp usage_info(info) do
    %{
      ip: parse_ip(info[:ip]),
      used_at: info[:used_at],
      user_agent: parse_user_agent(info[:user_agent])
    }
  end

  defp parse_ip(nil), do: nil

  defp parse_ip(ip) when is_binary(ip), do: ip

  defp parse_ip(ip_tuple) do
    ip_tuple
    |> Tuple.to_list()
    |> Enum.join(".")
  end

  defp parse_user_agent(nil), do: nil
  defp parse_user_agent(agent) when is_binary(agent), do: agent
  defp parse_user_agent([]), do: nil
  defp parse_user_agent([value | _]), do: value
end
