defmodule Erlef.MixProject do
  use Mix.Project

  def project do
    [
      app: :erlef,
      version: "0.1.0",
      elixir: "~> 1.13",
      elixirc_paths: elixirc_paths(Mix.env()),
      start_permanent: Mix.env() == :prod,
      test_coverage: [tool: ExCoveralls],
      preferred_cli_env: [coveralls: :test, "coveralls.html": :test],
      deps: deps(),
      aliases: aliases(),
      dialyzer: dialyzer_opts(),
      name: "Erlef",
      source_url: "https://github.com/erlef/website",
      homepage_url: "https://erlef.org/",
      docs: docs(),
      listeners: [Phoenix.CodeReloader],
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
      {:credo, "~> 1.7", only: [:dev, :test], runtime: false},
      {:dialyxir, "~> 1.0", only: [:dev, :test], runtime: false},
      {:earmark, "~> 1.4.20"},
      {:ecto, "~> 3.10", override: true},
      {:ecto_psql_extras, "~> 0.8.7"},
      {:ecto_sql, "~> 3.10"},
      {:etso, "~> 1.0"},
      {:ex_aws, "~> 2.2"},
      {:ex_aws_s3, "~> 2.3"},
      {:excoveralls, "~> 0.18.5"},
      {:extwitter, "~> 0.14.0"},
      {:faker, "~> 0.18.0", only: [:dev, :test]},
      {:floki, ">= 0.0.0", only: :test},
      {:gen_smtp, "~> 1.0"},
      {:gettext, "~> 1.0.0"},
      {:jason, "~> 1.3"},
      {:joken, "~> 2.4"},
      {:honeybadger, "~> 0.24.0"},
      {:html_sanitize_ex, "~> 1.4"},
      {:hackney, "~> 1.18"},
      {:lazy_html, ">= 0.1.0", only: :test},
      {:logflare_logger_backend, "~> 0.11.0"},
      {:mint, "~> 1.4"},
      {:mime, "~> 2.0"},
      {:oauther, "1.3.0"},
      {:phoenix, "~> 1.6"},
      {:phoenix_ecto, "~> 4.4"},
      {:phoenix_html, "~> 4.0"},
      {:phoenix_html_helpers, "~> 1.0"},
      {:phoenix_live_dashboard, "~> 0.8.6"},
      {:phoenix_live_reload, "~> 1.3", only: :dev},
      {:phoenix_live_view, "~> 1.0"},
      {:phoenix_swoosh, "~> 1.0"},
      {:phoenix_pubsub, "~> 2.0"},
      {:plug_attack, "~> 0.4.3"},
      {:plug_cowboy, "~> 2.5"},
      {:postgrex, ">= 0.0.0"},
      {:ranch, "~> 2.2"},
      {:slugify, "~> 1.3"},
      {:sobelow, "~> 0.10", only: [:dev, :test]},
      {:swoosh, "~> 1.6"},
      {:telemetry_poller, "~> 1.0"},
      {:telemetry_metrics, "~> 1.1"}
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
