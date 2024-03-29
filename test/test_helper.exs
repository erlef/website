Application.ensure_started(Erlef.WildApricot.Cache)
Application.ensure_started(Erlef.Test.S3)
ExUnit.start(exclude: [:pending])
Faker.start()

Ecto.Adapters.SQL.Sandbox.mode(Erlef.Repo, {:shared, self()})
