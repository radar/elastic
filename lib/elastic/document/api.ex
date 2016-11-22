defmodule Elastic.Document.API do
  @moduledoc ~S"""
  The Document API provides some helpers for interacting with documents.

  The Document API extracts away a lot of the repetition of querying /
  indexing of a particular index. Here's an example:

  ```
  defmodule Answer do
    @es_type "answer"
    @es_index "answer"
    use Elastic.Document.API

    defstruct id: nil, text: []
  end
  ```

  You may also specify the index at query/insertion as the last (optional) argument to
  all Document functions.  You will receive warnings if @es_index is undefined in
  the using module, but you may either ignore these or specify `@es_index "N/A"` or other
  unused value if a default index does not make sense for your collection, such as permission based
  partitioning, or per-company partitioning in a SaaS application.

  ## Index

  Then you can index a new `Answer` by doing:

  ```elixir
  Answer.index(1, %{text: "This is an answer"})
  ```

  or

  ```elixir
  Answer.index(1, %{text: "This is an answer"}, "explicit_named_index")
  ```

  if not using default index behavior.  All examples below may also be
  modified the same way if using an explicit index.

  ## Searching

  The whole point of Elastic Search is to search for things, and there's a
  function for that:

  ```elixir
  Answer.search(%{
    query: %{
      match: %{text: "answer"}
    },
  })
  ```

  The query syntax is exactly like the JSON you've come to know and love from
  using Elastic Search, except it's Elixir maps.

  This will return a list of `Answer` structs.

  ```
  [
    %Answer{id: 1, text: "This is an answer"},
    ...
  ]
  ```

  If you want the raw search result, use `raw_search` instead:

  ```
  Answer.raw_search(%{
    query: %{
      match: %{text: "answer"}
    },
  })
  ```

  This will return the raw result, without the wrapping of the structs:

  ```
  {:ok, 200,
   [
     %{"_id" => "1", "_index" => "answer",
       "_source" => %{"text" => "This is an answer"}, "_type" => "answer", "_version" => 1,
       "found" => true}
     }
     ...
   ]
  }
  ```

  ## Counting

  Counting works the same as searching, but instead of returning all the hits,
  it'll return a number.

  ```elixir
  Answer.count(%{
    query: %{
      match: %{text: "answer"}
    },
  })
  ```

  ## Get

  And you can get that answer with:

  ```elixir
  Answer.get(1)
  ```

  This will return an Answer struct:

  ```elixir
  %Answer{id: 1, text: "This is an answer"}
  ```

  ## Raw Get

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

  ## Updating

  You can update the answer by using `update` (or `index`, since `update` is just an "alias")

  ```elixir
  Answer.update(1, %{text: "This is an answer"})
  ```

  ## Deleting

  Deleting a document from the index is as easy as:

  ```elixir
  Answer.delete(1)
  ```
  """
  defmacro __using__(_) do
    quote do
      alias Elastic.Document
      alias Elastic.HTTP
      alias Elastic.Index
      alias Elastic.Query

      def index(id, data, es_index \\ @es_index) do
        Document.index(es_index, @es_type, id, data)
      end

      def update(id, data, es_index \\ @es_index) do
        Document.update(es_index, @es_type, id, data)
      end

      def get(id, es_index \\ @es_index) do
        case raw_get(id, es_index) do
          {:ok, 200, %{"_source" => source, "_id" => id}} ->
            into_struct(id, source)
          {:error, 404, %{"found" => false}} -> nil
          other -> other
        end
      end

      def delete(id, es_index \\ @es_index) do
        Document.delete(es_index, @es_type, id)
      end

      def raw_get(id, es_index \\ @es_index) do
        Document.get(es_index, @es_type, id)
      end

      def search(query, es_index \\ @es_index) do
        result = Query.build(es_index, query) |> Index.search
        {:ok, 200, %{"hits" => %{"hits" => hits}}} = result
        Enum.map(hits, fn (%{"_source" => source, "_id" => id}) ->
          into_struct(id, source)
        end)
      end

      def raw_search(query, es_index \\ @es_index) do
        search_query(query, es_index) |> Index.search
      end

      def search_query(query, es_index \\ @es_index) do
        Query.build(es_index, query)
      end

      def raw_count(query, es_index \\ @es_index) do
        Query.build(es_index, query) |> Index.count
      end

      def count(query) do
        {:ok, 200, %{"count" => count}} = raw_count(query)
        count
      end

      def index_exists? do
        Elastic.Index.exists?(@es_index)
      end

      defp into_struct(id, source) do
        item = for {key, value} <- source, into: %{},
          do: {String.to_atom(key), value}
        struct(__MODULE__, Map.put(item, :id, id))
      end
    end
  end
end
