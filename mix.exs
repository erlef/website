defmodule Erlef.MixProject do
  use Mix.Project

  def project do
    [
      app: :erlef,
      version: "0.1.0",
      elixir: "~> 1.11",
      elixirc_paths: elixirc_paths(Mix.env()),
      compilers: [:phoenix, :gettext] ++ Mix.compilers(),
      start_permanent: Mix.env() == :prod,
      test_coverage: [tool: ExCoveralls],
      preferred_cli_env: [coveralls: :test, "coveralls.html": :test],
      deps: deps(),
      aliases: aliases(),
      dialyzer: dialyzer_opts(),
      name: "Erlef",
      source_url: "https://github.com/erlef/website",
      homepage_url: "https://erlef.org/",
      docs: docs()
    ]
  end

  # Configuration for the OTP application.
  #
  # Type `mix help compile.app` for more information.
  def application do
    [
      mod: {Erlef.Application, []},
      extra_applications: extra_applications()
    ]
  end

  defp extra_applications() do
    [:logger, :runtime_tools, :os_mon, :swoosh, :plug_attack, :extwitter]
  end

  # Specifies which paths to compile per environment.
  defp elixirc_paths(:test), do: ["lib", "test/support"]
  defp elixirc_paths(:dev), do: ["lib", "test/support/fake_servers"]
  defp elixirc_paths(_), do: ["lib"]

  # Specifies your project dependencies.
  #
  # Type `mix help deps` for examples and options.
  defp deps do
    [
      {:credo, "~> 1.5.4", only: [:dev, :test], runtime: false},
      {:dialyxir, "~> 1.0", only: [:dev, :test], runtime: false},
      {:earmark, "~> 1.4.13", override: true},
      {:ecto_psql_extras, "~> 0.2"},
      {:ecto_sql, "~> 3.5.3"},
      {:etso, "~> 0.1.2"},
      {:ex_aws, "~> 2.1.6"},
      {:ex_aws_s3, "~> 2.1.0"},
      {:excoveralls, "~> 0.13"},
      {:extwitter, "~> 0.12.2"},
      {:faker, "~> 0.16.0", only: :test},
      {:floki, ">= 0.0.0", only: :test},
      {:gen_smtp, "~> 1.0", override: true},
      {:gettext, "~> 0.18.2"},
      {:jason, "~> 1.2.1", override: true},
      {:joken, "~> 2.0"},
      {:honeybadger, "~> 0.1"},
      {:html_sanitize_ex, "~> 1.4"},
      {:hackney, "~> 1.17.0"},
      {:oauther, "1.1.1"},
      {:phoenix, "~> 1.5.7"},
      {:phoenix_ecto, "~> 4.2.1"},
      {:phoenix_html, "~> 2.14.3"},
      {:phoenix_live_dashboard, "~> 0.4.0"},
      {:phoenix_live_reload, "~> 1.3.0", only: :dev},
      {:phoenix_live_view, "~> 0.15.2"},
      {:phoenix_swoosh, "~> 0.3.2"},
      {:phoenix_pubsub, "~> 2.0.0"},
      {:plug_attack, "~> 0.4.2"},
      {:plug_cowboy, "~> 2.4.1"},
      {:postgrex, ">= 0.0.0"},
      {:ranch, "~> 1.7.1", override: true},
      {:slugify, "~> 1.3"},
      {:sobelow, "~> 0.10", only: [:dev, :test]},
      {:swoosh, "~> 1.1"},
      {:telemetry_poller, "~> 0.5"},
      {:telemetry_metrics, "~> 0.4"},
      {:ex_doc, "~> 0.23", only: :dev, runtime: false}
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
        "ecto.drop --quiet",
        "ecto.create --quiet",
        "ecto.migrate --quiet",
        "test"
      ],
      "eef.gen.newsletter": [&gen_newsletter/1]
    ]
  end

  def docs do
    [
      main: "readme",
      logo: "assets/static/images/eef-avatar.png",
      extras: ["README.md"]
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
      plt_core_path: "priv/plts",
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
