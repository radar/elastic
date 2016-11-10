defmodule Elastic.Bulk do
  @moduledoc ~S"""
  Used to make requests to ElasticSearch's bulk API.


  Both `create` and `update` take a list of tuples

  The order of elements in each tuple is this:

  * Index
  * Type
  * ID
  * Data

  Here's how to use `create`:

  ```elixir
    Elastic.Bulk.create(
      [
        {Elastic.Index.name("answer"), "answer", "id-goes-here", %{text: "This is an answer"}}
      ]
    )
  ```

  It's worth noting here that you can choose to pass `nil` as the ID in these create
  requests; ElasticSearch will automatically generate an ID for you.
  """

  @doc """
    Makes bulk create requests to ElasticSearch.

    For more information see documentation on `Elastic.Bulk`.
  """
  def create(documents) do
    documents
    |> Enum.map(&create_document/1)
    |> call_bulk_api
  end

  @doc """
    Makes bulk update requests to ElasticSearch.

    For more information see documentation on `Elastic.Bulk`.
  """
  def update(documents) do
    documents
    |> Enum.map(&update_document/1)
    |> Enum.join("\n")
    |> call_bulk_api
  end

  defp create_document({index, type, id, document}) do
    [
      Poison.encode!(%{create: identifier(index, type, id)}),
      Poison.encode!(document)
    ] |> Enum.join("\n")
  end

  defp update_document({index, type, id, document}) do
    [
      Poison.encode!(%{update: identifier(index, type, id)}),
      Poison.encode!(%{doc: document})
    ] |> Enum.join("\n")
  end

  defp identifier(index, type, nil) do
    %{_index: index, _type: type}
  end

  defp identifier(index, type, id) do
    identifier(index, type, nil) |> Map.put(:_id, id)
  end

  defp call_bulk_api(queries) do
    queries = queries |> Enum.join("\n")
    Elastic.HTTP.bulk(body: queries)
  end
end
