Erlef.Test.WildApricot.start()
ExUnit.start()
Faker.start()

Ecto.Adapters.SQL.Sandbox.mode(Erlef.Repo, {:shared, self()})
