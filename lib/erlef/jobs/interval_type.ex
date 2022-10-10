defmodule Erlef.Jobs.IntervalType do
  @moduledoc """
  A custom Ecto type for dealing with Postgres intervals.
  """

  use Ecto.Type

  alias Ecto.Changeset

  @impl true
  def type(), do: :interval

  @impl true
  def cast(%{} = params) do
    data = %{
      months: 0,
      days: 0,
      secs: 0,
      microsecs: 0
    }

    types = %{
      months: :integer,
      days: :integer,
      secs: :integer,
      microsecs: :integer
    }

    cast_result =
      {data, types}
      |> Changeset.cast(params, Map.keys(types))
      |> Changeset.apply_action(:insert)

    case cast_result do
      {:error, _} ->
        :error

      success ->
        success
    end
  end

  def cast(_), do: :error

  @impl true
  def load(%{months: months, days: days, secs: secs}) do
    {:ok, %Postgrex.Interval{months: months, days: days, secs: secs}}
  end

  @impl true
  def dump(%{months: months, days: days, secs: secs}) do
    {:ok, %Postgrex.Interval{months: months, days: days, secs: secs}}
  end

  def dump(%{"months" => months, "days" => days, "secs" => secs}) do
    {:ok, %Postgrex.Interval{months: months, days: days, secs: secs}}
  end
end
