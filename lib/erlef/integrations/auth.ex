defmodule Erlef.Integrations.Auth do
  @moduledoc false

  alias Erlef.{Crypto, Integrations}
  alias Erlef.Integrations.AppKey

  def by_key(app_secret, type, usage_info, opts \\ []) do
    maybe_client_id = Keyword.get(opts, :client_id, nil)

    with {key_id, secret} <- hash_message(app_secret),
         %AppKey{} = key <- find_key(type, key_id, maybe_client_id),
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

  defp find_key(type, key_id, nil) do
    Integrations.find_key(key_id, type)
  end

  defp find_key(type, key_id, client_id) do
    Integrations.find_key(client_id, key_id, type)
  end

  defp hash_message(message) do
    case Crypto.hmac_encode(secret_key(), message) do
      <<key_id::binary-size(32), secret::binary-size(32)>> ->
        {key_id, secret}

      _ ->
        {:error, :unrecoverable}
    end
  end

  defp update_last_use(key, usage_info) do
    Integrations.update_app_key_last_used(key, usage_info(usage_info))
  end

  defp usage_info(info) do
    %{
      ip: info[:ip],
      used_at: info[:used_at],
      user_agent: parse_user_agent(info[:user_agent])
    }
  end

  defp parse_user_agent(nil), do: nil
  defp parse_user_agent(agent) when is_binary(agent), do: agent
  defp parse_user_agent([]), do: nil
  defp parse_user_agent([value | _]), do: value

  defp secret_key(), do: Application.get_env(:erlef, :secret)
end
