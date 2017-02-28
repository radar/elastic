# Elastic

[![Version](https://img.shields.io/hexpm/v/elastic.svg)](https://hex.pm/packages/elastic)
[![Travis Build](https://img.shields.io/travis/radar/elastic.svg)](https://travis-ci.org/radar/elastic)

_You Know, for (Elastic) Search._

Want to talk to Elastic Search in Elixir, but don't want to use raw HTTP calls? This package is for you.

## Installation

1. Add it as a dependency in `mix.exs`:

```elixir
defp deps do
  [
    {:elastic, "~> 1.0"}
  ]
```

2. Run `mix deps.get`

3. Add it to the applications list in `mix.exs`:

```elixir
def application do
  [applications: [:elastic]]
end
```

## Docs

Documentation can be found on [hexdocs.pm](https://hexdocs.pm/elastic/Elastic.html)

## There's a bug / pull request

[Create a new issue](https://github.com/radar/elastic/issues/new) or [submit a pull request](https://github.com/radar/elastic/compare) and follow the instructions.

## ElasticSearch version

This package is designed to work with ElasticSearch 2.4.x, since that's the version I am personally using.

I think if there are API compatibility issues with ElasticSearch 5.x then we should look at creating a branch for 5.x compatibility. Please submit a pull request to kick off this process.
