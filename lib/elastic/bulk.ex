defmodule Elastic.Bulk do
  def create(documents) do
    bulk_queries = documents
    |> Enum.map(&create_document/1)
    |> Enum.join("\n")

    Elastic.HTTP.bulk(body: bulk_queries <> "\n\n")
  end

  defp create_document({index, type, id, document}) do
    [
      Poison.encode!(%{create: create(index, type, id)}),
      Poison.encode!(document)
    ] |> Enum.join("\n")
  end

  def create(index, type, nil) do
    %{_index: index, _type: type}
  end

  def create(index, type, id) do
    create(index, type, nil) |> Map.put(:_id, id)
  end
end
