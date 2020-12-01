Application.ensure_all_started(:erlef)


if Erlef.is_env?(:dev) do 
  seeds_list = [
    "events",
    "academic_papers"
  ]

  for seeds <- seeds_list do
    file = Path.absname("priv/repo/seeds/#{seeds}.exs")
    Code.eval_file(file)
  end
end
