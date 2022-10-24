defmodule Erlef.MixProject do
  use Mix.Project

  def project do
    [
      app: :erlef,
      version: "0.1.0",
      elixir: "~> 1.13",
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
    [:logger, :runtime_tools, :os_mon, :swoosh, :plug_attack, :extwitter, :oauther]
  end

  # Specifies which paths to compile per environment.
  defp elixirc_paths(:test), do: ["lib", "test/support"]
  defp elixirc_paths(:dev), do: ["lib", "test/support", "test/support/fake_servers"]
  defp elixirc_paths(_), do: ["lib"]

  # Specifies your project dependencies.
  #
  # Type `mix help deps` for examples and options.
  defp deps do
    [
      {:credo, "~> 1.6.4", only: [:dev, :test], runtime: false},
      {:dialyxir, "~> 1.0", only: [:dev, :test], runtime: false},
      {:earmark, "~> 1.4.20", override: true},
      {:ecto, "~> 3.7.1"},
      {:ecto_psql_extras, "~> 0.7.4"},
      {:ecto_sql, "~> 3.7.2"},
      {:etso, "~> 0.1.2"},
      {:ex_aws, "~> 2.2.10"},
      {:ex_aws_s3, "~> 2.3.2"},
      {:excoveralls, "~> 0.14.4"},
      {:extwitter, "~> 0.13.1"},
      {:faker, "~> 0.17.0", only: [:dev, :test]},
      {:floki, ">= 0.0.0", only: :test},
      {:gen_smtp, "~> 1.0", override: true},
      {:gettext, "~> 0.19.1"},
      {:jason, "~> 1.3.0", override: true},
      {:joken, "~> 2.4.1"},
      {:honeybadger, "~> 0.18.1"},
      {:html_sanitize_ex, "~> 1.4.2"},
      {:hackney, "~> 1.18.1"},
      {:logflare_logger_backend, "~> 0.11.0"},
      {:mint, "~> 1.4.1", override: true},
      {:mime, "~> 2.0.2"},
      {:oauther, "1.3.0"},
      {:phoenix, "~> 1.6.6"},
      {:phoenix_ecto, "~> 4.4.0"},
      {:phoenix_html, "~> 3.2.0"},
      {:phoenix_live_dashboard, "~> 0.6.5"},
      {:phoenix_live_reload, "~> 1.3.3", only: :dev},
      {:phoenix_live_view, "~> 0.17.7"},
      {:phoenix_swoosh, "~> 1.0.1"},
      {:phoenix_pubsub, "~> 2.0.0"},
      {:plug_attack, "~> 0.4.3"},
      {:plug_cowboy, "~> 2.5.2"},
      {:postgrex, ">= 0.0.0"},
      {:ranch, "~> 1.7.1", override: true},
      {:slugify, "~> 1.3"},
      {:sobelow, "~> 0.10", only: [:dev, :test]},
      {:swoosh, "~> 1.6.3"},
      {:telemetry_poller, "~> 1.0"},
      {:telemetry_metrics, "~> 0.6.1"}
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
