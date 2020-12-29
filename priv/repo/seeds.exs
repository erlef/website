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
    "volunteers",
    "working_group_volunteers",
    "working_group_chairs"
  ]

  for seeds <- seeds_list do
    file = Path.absname("priv/repo/seeds/#{seeds}.exs")
    Code.eval_file(file)
  end

  # Add annual member as chair of all working groups
  {:ok, member} = Erlef.Accounts.get_member("wg_chair")
  {:ok, v} = Erlef.Groups.create_volunteer(%{name: member.name, member_id: member.id}) 
  for wg <- Erlef.Groups.list_working_groups() do 
    Erlef.Groups.create_working_group_volunteer(%{working_group_id: wg.id, volunteer_id: v.id})
    Erlef.Groups.create_working_group_chair(%{working_group_id: wg.id, volunteer_id: v.id})
  end

end
