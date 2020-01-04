defmodule App.Mixfile do
  use Mix.Project

  def project do
    [app: :app,
     version: "0.1.0",
     elixir: "~> 1.3",
     default_task: "server",
     build_embedded: Mix.env == :prod,
     start_permanent: Mix.env == :prod,
     deps: deps(),
    releases: [
      lambdinha: [
        include_executables_for: [:unix],
        applications: [runtime_tools: :permanent]
      ]
    ],
     aliases: aliases()]
  end

  def application do
    [applications: [:logger, :nadia, :httpoison],
     mod: {App, []}]
  end

  defp deps do
    [
      {:nadia, "0.4.4"},
      {:poison, "~> 3.1"},
      {:httpoison, "~>1.1.1"}
    ]
  end

  defp aliases do
    [server: "run --no-halt"]
  end
end
