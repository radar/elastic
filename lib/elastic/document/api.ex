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

  ## Index

  Then you can index a new `Answer` by doing:

  ```elixir
  Answer.index(1, %{text: "This is an answer"})
  ```

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
  %Answer{text: "This is an answer"}
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

      def index(id, data) do
        Document.index(@es_index, @es_type, id, data)
      end

      def update(id, data), do: index(id, data)

      def get(id) do
        case raw_get(id) do
          {:ok, 200, %{"_source" => source, "_id" => id}} ->
            into_struct(id, source)
          {:error, 404, %{"found" => false}} -> nil
          other -> other
        end
      end

      def delete(id) do
        Document.delete(@es_index, @es_type, id)
      end

      def raw_get(id) do
        Document.get(@es_index, @es_type, id)
      end

      def search(query) do
        Index.search(@es_index, query)
      end

      def count(query) do
        Index.count(@es_index, query)
      end


      defp into_struct(id, source) do
        item = for {key, value} <- source, into: %{},
          do: {String.to_atom(key), value}
        struct(__MODULE__, Map.put(item, :id, id))
      end
    end
  end
end
