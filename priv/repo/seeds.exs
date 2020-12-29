alias Erlef.Repo

defmodule Erlef.Seeds do 
  def insert(schema, data_set) do
    case Repo.insert_all(schema, data_set, on_conflict: :nothing) do
      {num_rows, nil} -> {:ok, num_rows}
      error -> {:error, error}
    end
  end
end

Application.ensure_all_started(:erlef)


if Erlef.is_env?(:dev) do 
  seeds_list = [
    "events",
    "academic_papers",
    "working_groups",
    "volunteers"
  ]

  for seeds <- seeds_list do
    file = Path.absname("priv/repo/seeds/#{seeds}.exs")
    Code.eval_file(file)
  end
end
