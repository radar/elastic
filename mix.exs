defmodule Elastic.Mixfile do
  use Mix.Project
  @version "3.0.0"

  def project do
    [app: :elastic,
     version: @version,
     elixir: "~> 1.3",
     build_embedded: Mix.env == :prod,
     start_permanent: Mix.env == :prod,
     elixirc_paths: elixirc_paths(Mix.env),
     package: package(),
     # Docs
     name: "Elastic",
     docs: [
      source_ref: "v#{@version}",
      main: "Elastic",
      canonical: "http://hexdocs.pm/elastic",
      source_url: "https://github.com/radar/elastic",
    ] ,
     deps: deps()]
  end

  def application do
    [applications: [:logger, :httpotion]]
  end

  defp elixirc_paths(:test), do: ["lib", "test/support"]
  defp elixirc_paths(_), do: ["lib"]

  defp deps do
    [
      {:httpotion, "~> 3.0"},
      {:poison, "~> 2.2 or ~> 3.0"},
      {:aws_auth, "~> 0.6"},
      {:credo, "~> 0.4", only: [:dev, :test]},
      {:ex_doc, ">= 0.0.0", only: :dev}
    ]
  end

  defp package do
    [
      name: :elastic,
      description: "You Know, for (Elastic) Search",
      files: ["lib", "README*", "mix.exs"],
      maintainers: ["Ryan Bigg"],
      licenses: ["MIT"],
      links: %{"GitHub" => "https://github.com/radar/elastic"}
    ]
  end
end
