defmodule Erlef.Integrations.AppKey do
  @moduledoc false

  use Erlef.Schema

  alias Erlef.Integrations.App

  schema "app_keys" do
    field(:name, :string)
    field(:type, Ecto.Enum, values: [:webhook, :api_read_only])
    field(:app_secret, :string, virtual: true)
    field(:key_id, :string)
    field(:secret, :string)
    field(:revoked_at, :utc_datetime)
    field(:revoked_by, Ecto.UUID)

    embeds_one :last_used, Useage, on_replace: :delete do
      field(:used_at, :utc_datetime_usec)
      field(:user_agent, :string)
      field(:ip, :string)
    end

    field(:created_by, Ecto.UUID)

    belongs_to(:app, App)
    timestamps()
  end

  @doc false
  def changeset(key, attrs) do
    key
    |> cast(attrs, [:type, :created_by, :name])
    |> validate_required([:type, :created_by, :name])
  end

  @doc false
  def create_changeset(key, attrs) do
    key
    |> cast(attrs, [:type, :created_by, :name])
    |> add_keys()
    |> validate_required([:type, :created_by])
    |> prepare_changes(&unique_name/1)
  end

  def update_last_use(key, params) do
    key
    |> change()
    |> put_embed(:last_used, struct(AppKey.Useage, params))
  end

  def revoke(key, %{updated_by: updated_by}) do
    key
    |> change()
    |> cast(%{revoked_at: DateTime.utc_now()}, [:revoked_at])
    |> put_change(:revoked_by, updated_by)
  end

  def build(app, params) do
    build_assoc(app, :keys)
    |> associate_app(app)
    |> create_changeset(params)
  end

  def revoked?(%AppKey{} = key) do
    not is_nil(key.revoked_at)
  end

  defp add_keys(changeset) do
    {app_secret, id, token} = gen_key()

    changeset
    |> put_change(:app_secret, app_secret)
    |> put_change(:key_id, id)
    |> put_change(:secret, token)
  end

  defp gen_key() do
    app_secret =
      :crypto.strong_rand_bytes(32)
      |> Base.encode16(case: :lower)

    our_secret = Application.get_env(:erlef, :secret)

    <<id::binary-size(32), token::binary-size(32)>> =
      :crypto.mac(:hmac, :sha3_256, our_secret, app_secret)
      |> Base.encode16(case: :lower)

    {app_secret, id, token}
  end

  defp unique_name(changeset) do
    {:ok, name} = fetch_change(changeset, :name)

    names =
      from(
        a in App,
        left_join: k in assoc(a, :keys),
        select: k.name
      )
      |> changeset.repo.all
      |> Enum.into(MapSet.new())

    name = if MapSet.member?(names, name), do: find_unique_name(name, names), else: name

    put_change(changeset, :name, name)
  end

  defp find_unique_name(name, names, counter \\ 2) do
    name_counter = "#{name}-#{counter}"

    if MapSet.member?(names, name_counter) do
      find_unique_name(name, names, counter + 1)
    else
      name_counter
    end
  end

  defp associate_app(nil, _app), do: nil
  defp associate_app(%AppKey{} = key, %App{} = app), do: %{key | app: app}
end
