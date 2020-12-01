Application.ensure_started(Erlef.WildApricot.Cache)
ExUnit.start()
Faker.start()

Ecto.Adapters.SQL.Sandbox.mode(Erlef.Repo, {:shared, self()})
