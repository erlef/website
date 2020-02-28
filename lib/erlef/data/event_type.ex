defmodule Erlef.Data.EventType do
  @moduledoc """
  Erlef.EventType schema
  """

  use Ecto.Schema
  import Ecto.Changeset

  @primary_key {:id, :binary_id, autogenerate: true}
  schema "event_types" do
    field(:name, :string)
    field(:detail, :string)
  end

  def changeset(struct, params \\ %{}) do
    struct
    |> cast(params, required_fields())
    |> validate_required(required_fields())
  end

  defp required_fields do
    [:name, :detail]
  end

end
