Erlef.Test.WildApricot.start()
Erlef.Test.Recaptcha.start()
ExUnit.start()
Faker.start()

Ecto.Adapters.SQL.Sandbox.mode(Erlef.Data.Repo, {:shared, self()})
