defmodule Elastic.Mixfile do
  use Mix.Project
  @version "3.5.3"

  def project do
    [
      app: :elastic,
      version: @version,
      elixir: "~> 1.5",
      build_embedded: Mix.env() == :prod,
      start_permanent: Mix.env() == :prod,
      elixirc_paths: elixirc_paths(Mix.env()),
      package: package(),
      # Docs
      name: "Elastic",
      docs: [
        source_ref: "v#{@version}",
        main: "Elastic",
        canonical: "http://hexdocs.pm/elastic",
        source_url: "https://github.com/radar/elastic"
      ],
      deps: deps()
    ]
  end

  def application do
    [applications: [:logger, :httpotion, :aws_auth, :jason]]
  end

  defp elixirc_paths(:test), do: ["lib", "test/support"]
  defp elixirc_paths(_), do: ["lib"]

  defp deps do
    [
      {:httpotion, "~> 3.1"},
      {:jason, "~> 1.1.2"},
      {:aws_auth, "~> 0.7.1"},
      {:credo, "~> 1.0", only: [:dev, :test]},
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
