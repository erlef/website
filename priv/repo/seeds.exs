alias Erlef.Repo

defmodule Erlef.Seeds do 
  def insert(schema, data_set) do
    now = DateTime.truncate(DateTime.utc_now(), :second)
    set_with_stamps = Enum.map(data_set, fn(d) -> Map.merge(d, %{inserted_at: now, updated_at: now}) end)
    case Repo.insert_all(schema, set_with_stamps, on_conflict: :nothing) do
      {num_rows, nil} -> {:ok, num_rows}
      error -> {:error, error}
    end
  end
end

Application.ensure_all_started(:erlef)

alias Erlef.{Accounts, Groups}

if Erlef.is_env?(:dev) do 
  seeds_list = [
    "events",
    "academic_papers",
    "working_groups",
    "volunteers",
    "working_group_volunteers",
    "working_group_chairs",
    "sponsors"
  ]

  for seeds <- seeds_list do
    file = Path.absname("priv/repo/seeds/#{seeds}.exs")
    Code.eval_file(file)
  end

  # Add wg_chair as chair of all working groups for dev/test purposes
  {:ok, admin_contact} = Erlef.Test.WildApricot.get_contact("admin")
  params = Accounts.to_member_params(admin_contact, %{from: :wildapricot})
  {:ok, admin} = Accounts.create_member(params)

  {:ok, wg_chair_contact} = Erlef.Test.WildApricot.get_contact("wg_chair")
  params = Accounts.to_member_params(wg_chair_contact, %{from: :wildapricot})
  {:ok, wg_chair} = Accounts.create_member(params)

  audit_data = %{member_id: admin.id} 
  {:ok, v} = Groups.create_volunteer(%{name: wg_chair.name, member_id: wg_chair.id}, audit: audit_data) 
  for wg <- Groups.list_working_groups() do 
    Groups.create_wg_volunteer(wg, v, audit: audit_data)
    Groups.create_wg_chair(wg, v, audit: audit_data)
  end

end
