defmodule Erlef.Data.Seeds do
  alias Erlef.Data.Repo

  def insert(schema, data_set) do
    case Repo.insert_all(schema, data_set, on_conflict: :nothing) do
      {num_rows, nil} -> {:ok, num_rows}
      error -> {:error, error}
    end
  end
end
