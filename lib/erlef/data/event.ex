defmodule Erlef.Data.Event do
  @moduledoc """
  Erlef.Event schema
  """

  use Ecto.Schema
  import Ecto.Changeset

  @primary_key {:id, :binary_id, autogenerate: true}
  # TODO: Hammer out fields in review before filling this out
  schema "events" do
  end

  def changeset(struct, params \\ %{}) do
    struct
    |> cast(params, required_fields() ++ optional_fields())
    |> validate_required(required_fields())
  end

  defp required_fields do
  end

  defp optional_fields do
  end
end
