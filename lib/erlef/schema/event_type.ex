defmodule Erlef.Schema.EventType do
  @moduledoc """
  Erlef.Schema.EventType schema
  """
  use Ecto.Schema
  import Ecto.Changeset

  @primary_key {:id, :binary_id, autogenerate: true}
  schema "event_types" do
    field(:name, :string)
  end

  def changeset(struct, params \\ %{}) do
    struct
    |> cast(params, [:name])
    |> validate_required([:name])
  end

  def get(type) do
    Erlef.Repo.get_by!(__MODULE__, name: Atom.to_string(type))
  end
end
