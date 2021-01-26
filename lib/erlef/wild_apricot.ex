defmodule Erlef.WildApricot do
  @moduledoc """
  Erlef.WildApricot Client

  This module provides a set of functions for performing common operations with
  the wildapricot api for use witthin the erlef app.

  ## Wildapricot

  The erlef uses wildapricot as a members database and ...

  ### Useful resources

   - https://gethelp.wildapricot.com/en/articles/182-using-wild-apricots-api
   - https://app.swaggerhub.com/apis-docs/WildApricot/wild-apricot_public_api/7.15.0
  """

  alias Erlef.WildApricot.Cache

  @wa_member_login "https://erlangecosystemfoundation.wildapricot.org"

  @spec gen_login_uri() :: no_return()
  def gen_login_uri() do
    domain = erlef_domain()

    :hackney_url.make_url(@wa_member_login, "/sys/login/OAuthLogin", [
      {"client_Id", client_id()},
      {"scope", "auto"},
      {"redirect_uri", "https://#{domain}/login"}
    ])
  end

  @spec login(String.t()) :: {:ok, map()} | {:error, term()}
  def login(code) do
    domain = erlef_domain()

    body =
      {:form,
       [
         {"grant_type", "authorization_code"},
         {"client_id", client_id()},
         {"code", code},
         {"redirect_uri", "https://#{domain}/login"},
         {"scope", "auto"}
       ]}

    headers = [{"Content-Type", "application/x-www-form-urlencoded"}]
    post(headers, body, [basic_client_auth()])
  end

  @spec refresh(String.t()) :: {:ok, map()} | {:error, term()}
  def refresh(refresh_token) do
    body =
      {:form,
       [
         {"grant_type", "refresh_token"},
         {"refresh_token", refresh_token}
       ]}

    headers = [{"Content-Type", "application/x-www-form-urlencoded"}]
    post(headers, body, [basic_api_auth()])
  end

  @spec logout(String.t(), String.t()) :: :ok | :error
  def logout(token, refresh_token) do
    token_url = :hackney_url.make_url(base_auth_url(), "/auth/expiretoken", [{"token", token}])

    refresh_token_url =
      :hackney_url.make_url(base_auth_url(), "/auth/deleterefreshtoken", [
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

  @spec me(String.t(), String.t() | nil) :: {:ok, map()} | {:error, term()}
  def me(uid, token \\ nil) do
    token = token || Erlef.WildApricot.Cache.get_token()
    uri = api_url() <> "/accounts/#{uid}/contacts/me"

    headers = [
      {"User-Agent", "erlef_app"},
      {"Accept", "application/json"},
      {"Authorization", "Bearer #{token}"}
    ]

    get(uri, headers)
  end

  @spec get_contact(term(), String.t() | nil) :: {:ok, map()} | {:error, term()}
  def get_contact(uid, token \\ nil) do
    token = token || Erlef.WildApricot.Cache.get_token()
    aid = account_id()
    uri = api_url() <> "/accounts/#{aid}/contacts/#{uid}"

    headers = [
      {"User-Agent", "erlef_app"},
      {"Accept", "application/json"},
      {"Authorization", "Bearer #{token}"}
    ]

    get(uri, headers)
  end

  def get_contact_by_field_value(field, value, token \\ nil) do
    token = token || Cache.get_token()
    aid = account_id()
    uri = api_url() <> "/accounts/#{aid}/contacts"

    params = %{"$async" => "false", "$filter" => "#{field} eq #{value}"}
    query_params = URI.encode_query(params)

    headers = [
      {"User-Agent", "erlef_app"},
      {"Accept", "application/json"},
      {"Authorization", "Bearer #{token}"}
    ]

    case get(uri <> "?#{query_params}", headers) do
      {:ok, %{"Contacts" => [contact]}} ->
        {:ok, contact}

      {:ok, %{"Contacts" => [_contact | _rest]}} ->
        {:error, :multiple_contacts_found}

      {:ok, %{"Contacts" => []}} ->
        {:error, :not_found}

      err ->
        err
    end
  end

  def update_contact(uid, params, token \\ nil) do
    token = token || Erlef.WildApricot.Cache.get_token()
    aid = account_id()
    uri = api_url() <> "/accounts/#{aid}/contacts/#{uid}"

    headers = [
      {"User-Agent", "erlef_app"},
      {"Accept", "application/json"},
      {"Content-Type", "application/json"},
      {"Authorization", "Bearer #{token}"}
    ]

    put(uri, headers, params)
  end

  def get_api_token do
    body =
      {:form,
       [{"grant_type", "client_credentials"}, {"obtain_refresh_token", true}, {"scope", "auto"}]}

    headers = [{"Content-Type", "application/x-www-form-urlencoded"}]
    post(headers, body, [basic_api_auth()])
  end

  def valid_account_id?(acct_id) do
    acct_id == account_id()
  end

  defp account_id(), do: config_get(:account_id)

  defp get(uri, headers, opts \\ []) do
    case Erlef.HTTP.perform(:get, uri, headers, "", opts) do
      {:ok, %{body: body}} ->
        {:ok, body}

      err ->
        err
    end
  end

  defp post(headers, body, opts) do
    case Erlef.HTTP.perform(:post, auth_url(), headers, body, opts) do
      {:ok, %{body: body}} ->
        {:ok, body}

      err ->
        err
    end
  end

  defp put(uri, headers, body, opts \\ []) do
    case Erlef.HTTP.perform(:put, uri, headers, body, opts) do
      {:ok, %{body: body}} ->
        {:ok, body}

      err ->
        err
    end
  end

  defp basic_api_auth, do: {:basic_auth, {"APIKEY", api_key()}}
  defp basic_client_auth, do: {:basic_auth, {client_id(), client_secret()}}
  defp api_key, do: config_get(:api_key)
  defp client_id, do: config_get(:client_id)
  defp client_secret, do: config_get(:client_secret)
  defp base_auth_url, do: config_get(:base_auth_url)
  defp base_api_url, do: config_get(:base_api_url)
  defp auth_url, do: base_auth_url() <> "/auth/token"
  defp api_url(), do: base_api_url() <> "/v2.2"
  defp erlef_domain, do: Application.get_env(:erlef, :domain)

  defp config_get(key) do
    props = Application.get_env(:erlef, :wild_apricot)
    Keyword.get(props, key)
  end
end
