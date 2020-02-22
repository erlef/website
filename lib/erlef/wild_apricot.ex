defmodule Erlef.WildApricot do
  @moduledoc """
  Erlef.WildApricot Client
  """

  @base_auth_url "https://oauth.wildapricot.org"
  @base_auth_url Application.get_env(:erlef, :wild_apricot_base_auth_url)
  @auth_path "/auth/token"
  @expire_auth_path "/auth/expiretoken"
  @expire_refresh_path "/auth/deleterefreshtoken"
  @auth_url @base_auth_url <> @auth_path
  @base_api_url Application.get_env(:erlef, :wild_apricot_base_api_url)
  @api_url @base_api_url <> "/v2.1"

  @spec user_login(String.t(), String.t()) :: {:ok, map()} | {:error, term()}
  def user_login(user, password) do
    body =
      {:form,
       [
         {"grant_type", "password"},
         {"username", user},
         {"password", password},
         {"scope", "auto"},
         {"includeDetails", true}
       ]}

    headers = [{"Content-Type", "application/x-www-form-urlencoded"}]
    post(headers, body, [basic_client_auth()])
  end

  @spec user_refresh(String.t()) :: {:ok, map()} | {:error, term()}
  def user_refresh(refresh_token) do
    body =
      {:form,
       [
         {"grant_type", "refresh_token"},
         {"refresh_token", refresh_token}
       ]}

    headers = [{"Content-Type", "application/x-www-form-urlencoded"}]
    post(headers, body, [basic_api_auth()])
  end

  def refresh_token(token), do: user_refresh(token)

  @spec user_logout(String.t(), String.t()) :: :ok | :error
  def user_logout(token, refresh_token) do
    token_url = :hackney_url.make_url(@base_auth_url, @expire_auth_path, [{"token", token}])

    refresh_token_url =
      :hackney_url.make_url(@base_auth_url, @expire_refresh_path, [
        {"refreshToken", refresh_token}
      ])

    with {:ok, _} <- get(token_url, []),
         {:ok, _} <- get(refresh_token_url, []) do
      :ok
    else
      _ ->
        :error
    end
  end

  @spec me(String.t(), integer()) :: {:ok, map()} | {:error, term()}
  def me(token, uid) do
    uri = @api_url <> "/accounts/#{uid}/contacts/me"

    headers = [
      {"User-Agent", "erlef_app"},
      {"Accept", "application/json"},
      {"Authorization", "Bearer #{token}"}
    ]

    get(uri, headers)
  end

  @spec is_admin(String.t(), integer(), integer()) :: boolean()
  def is_admin(token, aid, id) do
    uri = @api_url <> "/accounts/#{aid}/contacts/#{id}"

    headers = [
      {"User-Agent", "erlef_app"},
      {"Accept", "application/json"},
      {"Authorization", "Bearer #{token}"}
    ]

    {:ok, body} = get(uri, headers)
    body |> get_groups() |> in_admin?()
  end

  def get_api_token do
    body =
      {:form,
       [{"grant_type", "client_credentials"}, {"obtain_refresh_token", true}, {"scope", "auto"}]}

    headers = [{"Content-Type", "application/x-www-form-urlencoded"}]
    post(headers, body, [basic_api_auth()])
  end

  defp get(uri, headers) do
    case Erlef.HTTP.perform(:get, uri, headers, "", []) do
      {:ok, %{body: body}} ->
        {:ok, body}

      err ->
        err
    end
  end

  defp post(headers, body, opts) do
    case Erlef.HTTP.perform(:post, @auth_url, headers, body, opts) do
      {:ok, %{body: body}} ->
        {:ok, body}

      err ->
        err
    end
  end

  defp get_groups(body) do
    case Enum.find(body["FieldValues"], fn x -> x["FieldName"] == "Group participation" end) do
      %{"Value" => groups} ->
        groups

      _ ->
        []
    end
  end

  defp in_admin?([]), do: false

  defp in_admin?(groups) when is_list(groups) do
    case Enum.find(groups, fn x -> x["Label"] == "Website Admin" end) do
      %{"Label" => "Website Admin"} -> true
      _ -> false
    end
  end

  defp in_admin?(_), do: false

  defp basic_api_auth, do: {:basic_auth, {"APIKEY", api_key()}}

  defp basic_client_auth, do: {:basic_auth, {client_id(), client_secret()}}

  defp api_key, do: System.get_env("WAPI_API_KEY")

  defp client_id, do: System.get_env("WAPI_CLIENT_ID")

  defp client_secret, do: System.get_env("WAPI_CLIENT_SECRET")
end
