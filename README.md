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
    {:elastic, "~> 3.0"}
  ]
```

2. Run `mix deps.get`

3. Add it to the applications list in `mix.exs`:

```elixir
def application do
  [extra_applications: [:elastic]]
end
```

## Docs

Documentation can be found on [hexdocs.pm](https://hexdocs.pm/elastic/Elastic.html)

## There's a bug / I have a feature request

If you've found a bug, please [create a new issue](https://github.com/radar/elastic/issues/new) or [submit a pull request](https://github.com/radar/elastic/compare) to fix that bug.

If you've got a feature request, then please submit a pull request which adds the functionality you want.

## ElasticSearch version

This package is designed to work with and routinely tested against the following ElasticSearch versions:

- 2.4.x
- 5.x
- 6.x

If you find any incompatibility issues, please file a GitHub issue about it here, or even better open a pull request to fix it. Thanks!

## Elastic / Elastix / Tirexs

There's a similar package called [Elastix](https://github.com/werbitzky/elastix), which provides similar functionality. I only found out about this package _after_ I wrote Elastic and was using it in production; after first trialling [tirexs](https://github.com/Zatvobor/tirexs) -- and not finding its code very easy to understand.

It looks like the creator of Elastix and I have similar design ideals, so it really does come down to personal choice when deciding which library to use. I think Elastic has [better documentation](https://hexdocs.pm/elastic/). Elastix has a Mapping API, but Elastic has a Scrolling API.

Choose your own adventure ;)
