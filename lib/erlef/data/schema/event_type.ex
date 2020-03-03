defmodule Erlef.Data.Schema.EventType do
  @moduledoc """
  Erlef.Data.Schema.EventType schema
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
end
