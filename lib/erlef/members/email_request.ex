defmodule Erlef.Members.EmailRequest do
  @moduledoc """
  Erlef.Members.EmailRequest
  """
  use Erlef.Schema

  @derive {Jason.Encoder,
           only: [:id, :type, :username, :status, :submitted_by_id, :assigned_to_id]}
  @type t :: %__MODULE__{
          id: Ecto.UUID.t(),
          type: String.t(),
          username: String.t(),
          status: String.t(),
          submitted_by_id: Ecto.UUID.t()
        }

  @required_fields [
    :type,
    :username,
    :status,
    :submitted_by_id
  ]

  @optional_fields [
    :assigned_to_id
  ]

  @all_fields @required_fields ++ @optional_fields

  schema "member_email_requests" do
    field(:type, Ecto.Enum, values: [:email_box, :email_alias])
    field(:username, :string)
    field(:status, Ecto.Enum, values: [:created, :in_progress, :completed])

    belongs_to(:submitted_by, Erlef.Accounts.Member)
    belongs_to(:assigned_to, Erlef.Accounts.Member)

    embeds_many(:logs, LogEntry, primary_key: false, on_replace: :delete) do
      field(:type, Ecto.Enum, values: [:email_box, :email_alias])
      field(:username, :string)
      field(:status, Ecto.Enum, values: [:created, :in_progress, :completed])
      field(:submitted_by_id, Ecto.UUID)
      field(:assigned_to, Ecto.UUID)
      field(:assigned_to_id, Ecto.UUID)
      timestamps()
    end

    timestamps()
  end

  @spec changeset(%__MODULE__{}, map()) :: Ecto.Changeset.t()
  def changeset(struct, params) do
    struct
    |> cast(params, @all_fields)
    |> validate_required(@required_fields)
    |> validate_format(:username, ~r/^[A-Za-z0-9\._]+\Z/)
    |> validate_length(:username, min: 1, max: 40)
    |> maybe_add_log_entry()
  end

  defp maybe_add_log_entry(%{data: %{id: nil}} = cs) do
    cs
  end

  defp maybe_add_log_entry(cs) do
    req = cs.data

    entry =
      req
      |> Map.delete(:assigned_to)
      |> Map.delete(:logs)
      |> Map.delete(:id)
      |> Map.delete(:__meta__)
      |> Map.delete(:submitted_by)
      |> Map.delete(:__struct__)

    put_embed(cs, :logs, [entry | req.logs])
  end

  def get(id) do
    from(e in __MODULE__,
      join: m in assoc(e, :submitted_by),
      left_join: ma in assoc(e, :assigned_to),
      where: e.id == ^id,
      preload: [submitted_by: m, assigned_to: ma]
    )
  end
end
