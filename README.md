# Elastic

![https://img.shields.io/hexpm/v/elastic.svg](Version)
![https://img.shields.io/travis/radar/elastic.svg](Travis Build)

_You Know, for (Elastic) Search._

Want to talk to Elastic Search in Elixir, but don't want to use raw HTTP calls? This package is for you.

## Installation

1. Add it as a dependency in `mix.exs`:

```elixir
defp deps do
  [
    {:elastic, "~> 1.0.0"}
  ]
```

2. Run `mix deps.get`

3. Add it to the applications list in `mix.exs`:

```elixir
def application do
  [applications: [:elastic]]
end
```

## Usage

### Configuration

You can configure the way Elastic behaves by using the following configuration options:

* `index_prefix`: A prefix to use for all indexes. Only used when using the Document API, or `Elastic.Index`.
* `use_mix_env`: Adds `Mix.env` to an index, so that the index name used is something like `dev_answer`. Can be used in conjunction with `index_prefix` to get things like `company_dev_answer` as the index name.

### Document API

The Document API extracts away a lot of the repetition of querying / indexing of a particular index. Here's an example:

```
defmodule Answer do
  @es_type "answer"
  @es_index "answer"
  use Elastic.Document.API

  defstruct id: nil, text: []
end
```

#### Index

Then you can index a new `Answer` by doing:

```elixir
Answer.index(1, %{text: "This is an answer"})
```

#### Searching

The whole point of Elastic Search is to search for things, and there's a function for that:

```elixir
Answer.search(%{
  query: %{
    match: %{text: "answer"}
  },
})
```

The query syntax is exactly like the JSON you've come to know and love from using Elastic Search, except it's Elixir maps.

#### Get

And you can get that answer with:

```elixir
Answer.get(1)
```

This will return an Answer struct:

```elixir
%Answer{text: "This is an answer"}
```

#### Raw Get

If you want the raw result, use `raw_get` instead:

```elixir
Answer.raw_get(1)
```

This returns the raw data from Elastic Search, without the wrapping of the struct:

```elixir
{:ok, 200,
 %{"_id" => "1", "_index" => "answer",
   "_source" => %{"text" => "This is an answer"}, "_type" => "answer", "_version" => 1,
   "found" => true}
 }
}
```

#### Updating

You can update the answer by using `update` (or `index`, since `update` is just an "alias")

```elixir
Answer.update(1, %{text: "This is an answer"})
```

#### Deleting

Deleting a document from the index is as easy as:

```elixir
Answer.delete(1)
```

### HTTP API

If you want to make raw HTTP requests, you can use `Elastic.HTTP` which is a very thin veneer on top of `HTTPotion`.

```elixir
Elastic.HTTP.get("/index_goes_here/_search")
```

This returns something like:

```elixir
{:ok, 200,
 %{"_shards" => %{"failed" => 0, ...
```

## Intentionally missing features

* Query DSL (just use Maps!)
* Confusing syntax (readable code makes debugging a dream)

## Disclaimer

(This package is an _unofficial_ one, and is not supported by the company by the same name: [Elastic](https://www.elastic.co/).
