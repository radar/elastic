# Elastic

![Version](https://img.shields.io/hexpm/v/elastic.svg)
![Travis Build](https://img.shields.io/travis/radar/elastic.svg)

_You Know, for (Elastic) Search._

Want to talk to Elastic Search in Elixir, but don't want to use raw HTTP calls? This package is for you.

## Installation

1. Add it as a dependency in `mix.exs`:

```elixir
defp deps do
  [
    {:elastic, "~> 0.9.0"}
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

[Create a new issue](/issues/new) or [submit a pull request](/compare) and follow the instructions.
