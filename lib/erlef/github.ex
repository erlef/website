defmodule Erlef.Github do
  @moduledoc """
  Erlef.Github Client

  This module provides a set of functions for performing common operations with
  github's rest api for use within the erlef app.

  ## Useful resources

   -  https://docs.github.com/en/free-pro-team@latest/rest
   - 
  """

  alias Erlef.Github.Token

  @spec auth_app() :: {:ok, map()} | {:error, term()}
  def auth_app() do
    {:ok, jwt, _claims} = Token.gen_app_token(config_get(:app_id), config_get(:key_pem))

    headers = [
      {"Accept", "application/vnd.github.v3+json"},
      {"Content", "application/vnd.github.v3+json"},
      {"Authorization", "Bearer #{jwt}"}
    ]

    case post("/app/installations/#{app_install_id()}/access_tokens", headers, "", []) do
      {:ok, %{"token" => token}} ->
        {:ok, token}

      err ->
        err
    end
  end

  @spec create_files(String.t(), map()) :: {:ok, term()} | {:error, term()}
  def create_files(token, args) do
    blobs =
      Enum.map(args.files, fn f ->
        {:ok, %{"sha" => blob_sha}} =
          create_blob(token, %{owner: args.owner, repo: args.repo, content: f.content})

        %{
          path: f.path,
          mode: "100644",
          type: "blob",
          sha: blob_sha
        }
      end)

    create_tree(token, Map.put(args, :tree, blobs))
  end

  @spec create_branch(String.t(), map()) :: {:ok, term()} | {:error, term()}
  def create_branch(token, args) do
    res =
      create_ref(token, %{
        owner: args.owner,
        repo: args.repo,
        ref: "refs/heads/#{args.name}",
        sha: args.sha
      })

    case res do
      {:ok, %{"object" => branch}} ->
        {:ok, branch}

      err ->
        err
    end
  end

  @spec create_commit(String.t(), map()) :: {:ok, term()} | {:error, term()}
  def create_commit(token, args) do
    headers = token_auth_headers(token)
    post("/repos/#{args.owner}/#{args.repo}/git/commits", headers, args, [])
  end

  @spec create_pr(String.t(), map()) :: {:ok, term()} | {:error, term()}
  def create_pr(token, args) do
    headers = token_auth_headers(token)
    post("/repos/#{args.owner}/#{args.repo}/pulls", headers, args, [])
  end

  @spec get_main_last_commit(String.t(), map()) :: {:ok, term} | {:error, term()}
  def get_main_last_commit(token, args) do
    headers = token_auth_headers(token)

    case get("/repos/#{args.owner}/#{args.repo}/branches/main", headers, []) do
      {:ok, %{"commit" => last_commit}} ->
        {:ok, last_commit}

      err ->
        err
    end
  end

  defp create_ref(token, args) do
    headers = token_auth_headers(token)
    post("/repos/#{args.owner}/#{args.repo}/git/refs", headers, args, [])
  end

  defp create_blob(token, args) do
    headers = token_auth_headers(token)
    post("/repos/#{args.owner}/#{args.repo}/git/blobs", headers, args, [])
  end

  defp create_tree(token, args) do
    headers = token_auth_headers(token)
    post("/repos/#{args.owner}/#{args.repo}/git/trees", headers, args, [])
  end

  defp get(path, headers, opts) do
    case Erlef.HTTP.perform(:get, "https://api.github.com#{path}", headers, "", opts) do
      {:ok, %{body: body}} ->
        {:ok, body}

      err ->
        err
    end
  end

  defp post(path, headers, body, opts) do
    case Erlef.HTTP.perform(:post, "https://api.github.com#{path}", headers, body, opts) do
      {:ok, %{body: body}} ->
        {:ok, body}

      err ->
        err
    end
  end

  defp token_auth_headers(token) do
    [
      {"Accept", "application/vnd.github.v3+json"},
      {"Content-Type", "application/json"},
      {"Authorization", "token #{token}"}
    ]
  end

  defp app_install_id, do: config_get(:app_install_id)

  defp config_get(key) do
    props = Application.get_env(:erlef, :github)
    Keyword.get(props, key)
  end
end
