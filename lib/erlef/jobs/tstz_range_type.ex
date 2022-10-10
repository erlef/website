defmodule Erlef.Jobs.TstzRangeType do
  @moduledoc false

  use Ecto.Type

  def type(), do: :tstzrange

  def cast(nil), do: {:ok, nil}
  def cast(%Postgrex.Range{} = range), do: {:ok, from_postgrex(range)}
  def cast(%{} = range), do: {:ok, range}
  def cast(_), do: :error

  def load(nil), do: {:ok, nil}
  def load(%Postgrex.Range{} = range), do: {:ok, from_postgrex(range)}
  def load(_), do: :error

  def dump(nil), do: {:ok, nil}
  def dump(%{} = range), do: {:ok, to_postgrex(range)}
  def dump(_), do: :error

  defp from_postgrex(%Postgrex.Range{} = range), do: Map.from_struct(range)

  defp to_postgrex(%{} = range), do: struct!(Postgrex.Range, range)
end
