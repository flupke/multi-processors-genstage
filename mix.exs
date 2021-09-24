defmodule MultiProcessorsGenstage.MixProject do
  use Mix.Project

  def project do
    [
      app: :multi_processors_genstage,
      version: "0.1.0",
      elixir: "~> 1.12",
      start_permanent: Mix.env() == :prod,
      deps: deps()
    ]
  end

  # Run "mix help compile.app" to learn about applications.
  def application do
    [
      extra_applications: [:logger],
      mod: {MultiProcessorsGenstage.Application, []}
    ]
  end

  # Run "mix help deps" to learn about dependencies.
  defp deps do
    [
      {:gen_stage, "~> 1.1"},
      {:telemetry_metrics, "~> 0.6"},
      {:telemetry_metrics_logger, "~> 0.1"}
    ]
  end
end
