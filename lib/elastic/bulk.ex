defmodule Elastic.Bulk do
  def create(documents) do
    bulk_queries = documents
    |> Enum.map(&create_document/1)
    |> Enum.join("\n")

    Elastic.HTTP.bulk(body: bulk_queries <> "\n\n")
  end

  def update(documents) do
    bulk_queries = documents
    |> Enum.map(&update_document/1)
    |> Enum.join("\n")

    Elastic.HTTP.bulk(body: bulk_queries <> "\n\n")
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

  def identifier(index, type, nil) do
    %{_index: index, _type: type}
  end

  def identifier(index, type, id) do
    identifier(index, type, nil) |> Map.put(:_id, id)
  end
end
