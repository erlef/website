defmodule Erlef.Integrations.Auth do
  @moduledoc false

  alias Erlef.{Crypto, Integrations}
  alias Erlef.Integrations.AppKey

  def by_key(app_secret, type, usage_info, opts \\ []) do
    maybe_client_id = Keyword.get(opts, :client_id, nil)

    with {:ok, {key_id, secret}} <- hash_secret(app_secret),
         {:ok, key} <- find_key(type, key_id, maybe_client_id),
         {:ok, key} <- check_secret(key, secret),
         {:ok, key} <- check_revoked(key),
         {:ok, _key} <- update_last_use(key, usage_info(usage_info)) do
      :ok
    else
      {:error, :revoked} ->
        :revoked

      _ ->
        :error
    end
  end

  defp check_secret(key, secret) do
    case Crypto.compare(key.secret, secret) do
      true ->
        {:ok, key}

      false ->
        {:error, :bad_secret}
    end
  end

  defp check_revoked(key) do
    case AppKey.revoked?(key) do
      true ->
        {:error, :revoked}

      false ->
        {:ok, key}
    end
  end

  defp find_key(type, key_id, nil) do
    case Integrations.find_key(key_id, type) do
      %AppKey{} = key -> {:ok, key}
      _ -> {:error, :app_key_not_found}
    end
  end

  defp find_key(type, key_id, client_id) do
    case Integrations.find_key(client_id, key_id, type) do
      %AppKey{} = key -> {:ok, key}
      _ -> {:error, :app_key_not_found}
    end
  end

  defp hash_secret(message) do
    case Crypto.hmac_encode(secret_key(), message) do
      <<key_id::binary-size(32), secret::binary-size(32)>> ->
        {:ok, {key_id, secret}}

      _ ->
        {:error, :unrecoverable}
    end
  end

  defp update_last_use(key, usage_info) do
    case Integrations.update_app_key_last_used(key, usage_info(usage_info)) do
      %AppKey{} -> {:ok, key}
      err -> err
    end
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
