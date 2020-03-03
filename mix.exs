defmodule Erlef.MixProject do
  use Mix.Project

  def project do
    [
      app: :erlef,
      version: "0.1.0",
      elixir: "~> 1.10.1",
      elixirc_paths: elixirc_paths(Mix.env()),
      compilers: [:phoenix, :gettext] ++ Mix.compilers(),
      start_permanent: Mix.env() == :prod,
      test_coverage: [tool: ExCoveralls],
      preferred_cli_env: [coveralls: :test, "coveralls.html": :test],
      deps: deps(),
      aliases: aliases(),
      dialyzer: dialyzer_opts()
    ]
  end

  # Configuration for the OTP application.
  #
  # Type `mix help compile.app` for more information.
  def application do
    [
      mod: {Erlef.Application, []},
      extra_applications: [:logger, :runtime_tools, :swoosh, :plug_attack, :extwitter]
    ]
  end

  # Specifies which paths to compile per environment.
  defp elixirc_paths(:test), do: ["lib", "test/support"]
  defp elixirc_paths(_), do: ["lib"]

  # Specifies your project dependencies.
  #
  # Type `mix help deps` for examples and options.
  defp deps do
    [
      {:phoenix, "~> 1.4.14"},
      {:phoenix_ecto, "~> 4.1"},
      {:phoenix_pubsub, "~> 1.1"},
      {:phoenix_html, "~> 2.14"},
      {:phoenix_live_reload, "~> 1.2", only: :dev},
      {:phoenix_live_view, "~> 0.8.1"},
      {:ecto_sql, "~> 3.1"},
      {:postgrex, ">= 0.0.0"},
      {:gettext, "~> 0.17.4"},
      {:jason, "~> 1.1", override: true},
      {:plug_cowboy, "~> 2.1"},
      {:earmark, "~> 1.4.3", override: true},
      {:excoveralls, "~> 0.12.2"},
      {:timex, "~> 3.6"},
      {:swoosh, "~> 0.24.4"},
      {:phoenix_swoosh, "~> 0.2.0"},
      {:gen_smtp, "~> 0.15.0"},
      {:dialyxir, "~> 1.0.0-rc.7", only: [:dev, :test], runtime: false},
      {:credo, "~> 1.2.2", only: [:dev, :test], runtime: false},
      {:etso, "~> 0.1.1"},
      {:plug_attack, "~> 0.4.2"},
      {:ex_machina, "~> 2.3", only: :test},
      {:floki, ">= 0.0.0", only: :test},
      {:faker, "~> 0.13.0", only: :test},
      {:elixir_uuid, "~> 1.2"},
      {:slugify, "~> 1.2"},
      {:extwitter, "~> 0.12.0"},
      {:oauther, "1.1.1"},
      {:ex_aws, "~> 2.1"},
      {:ex_aws_s3, "~> 2.0"}
    ]
  end

  defp aliases do
    [
      "ecto.setup": [
        "ecto.create",
        "ecto.migrate",
        "run priv/repo/seeds.exs"
      ],
      "ecto.reset": ["ecto.drop", "ecto.setup"],
      test: [
        "compile --warnings-as-errors",
        "ecto.create --quiet",
        "ecto.migrate --quiet",
        "test"
      ],
      "eef.gen.newsletter": [&gen_newsletter/1]
    ]
  end

  defp gen_newsletter(_arg) do
    id = 1 + (Path.wildcard("priv/posts/newsletter/**/*.md") |> Enum.count())

    args = [
      "newsletter",
      "newsletter-#{id}",
      "-a",
      "eef",
      "-t",
      "EEF Newsletter ##{id}",
      "-e",
      "",
      "-b",
      default_newsletter_body(),
      "-p",
      "priv/posts/newsletter"
    ]

    Mix.Task.run("eef.gen.post", args)
  end

  defp dialyzer_opts do
    [
      plt_add_apps: [:mix, :ex_unit],
      remove_defaults: [:unknown],
      checks: [
        {Credo.Check.Refactor.MapInto, false},
        {Credo.Check.Warning.LazyLogging, false}
      ],
      plt_file: {:no_warn, "priv/plts/erlef.plt"}
    ]
  end

  defp default_newsletter_body do
    """
    ## In This Newsletter
    ------------------------------------------------------------
    Some text

    ## Working Group Water Cooler
    ------------------------------------------------------------
    Some text

    ## Ecosystem News
    ------------------------------------------------------------
    Some text

    ## See you Soon!
    ------------------------------------------------------------
    Some text

    """
  end
end
