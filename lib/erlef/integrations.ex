defmodule Erlef.Integrations do
  @moduledoc false

  import Ecto.Query, only: [from: 2]
  alias Erlef.Repo
  alias Erlef.Integrations.{App, AppKey}

  import Erlef.Context

  def list_apps do
    Repo.all(App)
  end

  def get_app!(id), do: Repo.get!(App, id)

  def get_app_with_keys!(id), do: Repo.one!(App.get_with_keys(id))

  def create_app(attrs \\ %{}, audit: audit) do
    %App{}
    |> App.changeset(audit_attrs(:create, attrs, audit))
    |> Repo.insert()
  end

  def get_app_key!(id), do: Repo.get!(AppKey, id)

  def create_app_key(app, attrs \\ %{}, audit: audit) do
    app
    |> AppKey.build(audit_attrs(:create, attrs, audit))
    |> Repo.insert()
  end

  def update_app(%App{} = app, attrs, audit: audit) do
    app
    |> App.changeset(audit_attrs(:update, attrs, audit))
    |> Repo.update()
  end

  def update_app_key_last_used(key, usage_info) do
    key
    |> AppKey.update_last_use(usage_info)
    |> Repo.update!()
  end

  def revoke_app_key(app_key, audit: audit) do
    app_key
    |> AppKey.revoke(audit_attrs(:create, %{}, audit))
    |> Repo.update()
  end

  def find_key(client_id, key_id, type) do
    from(
      k in AppKey,
      join: a in assoc(k, :app),
      where: k.key_id == ^key_id and a.client_id == ^client_id and k.type == ^type,
      preload: [app: a]
    )
    |> Repo.one()
  end
end
