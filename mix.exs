defmodule PeridiodPersistence.MixProject do
  use Mix.Project

  def project do
    [
      app: :peridiod_persistence,
      version: "0.1.0",
      elixir: "~> 1.17",
      start_permanent: Mix.env() == :prod,
      deps: deps()
    ]
  end

  # Run "mix help compile.app" to learn about applications.
  def application do
    [
      extra_applications: [:logger],
      mod: {PeridiodPersistence.Application, []}
    ]
  end

  # Run "mix help deps" to learn about dependencies.
  defp deps do
    [
      {:uboot_env, "~> 1.0"},
      {:jason, "~> 1.0"}
    ]
  end
end
