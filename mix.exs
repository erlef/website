defmodule Erlef.MixProject do
  use Mix.Project

  def project do
    [
      app: :erlef,
      version: "0.1.0",
      elixir: "~> 1.6",
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
      extra_applications: [:logger, :runtime_tools, :swoosh]
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
      {:phoenix, "~> 1.4.12"},
      {:phoenix_pubsub, "~> 1.1"},
      {:phoenix_html, "~> 2.14"},
      {:phoenix_live_reload, "~> 1.2", only: :dev},
      {:gettext, "~> 0.17.4"},
      {:jason, "~> 1.1", override: true},
      {:plug_cowboy, "~> 2.1"},
      {:earmark, "~> 1.4.3", override: true},
      {:excoveralls, "~> 0.12.2"},
      {:timex, "~> 3.6"},
      {:swoosh, "~> 0.24.4"},
      {:phoenix_swoosh, "~> 0.2.0"},
      {:gen_smtp, "~> 0.15.0"},
      {:dialyxir, "~> 1.0.0-rc.6", only: [:dev], runtime: false},
      {:credo, "~> 1.2.2", only: [:dev, :test], runtime: false},
      {:etso, "~> 0.1.1"}
    ]
  end

  defp aliases do
    [
      test: ["compile --warnings-as-errors", "test"],
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
      ]
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
