defmodule Elastic.Document do
  @moduledoc false

  alias Elastic.HTTP
  def index(index, type, id, data) do
    document_path(index, type, id) |> HTTP.put(body: data)
  end

  def get(index, type, id) do
    document_path(index, type, id) |> HTTP.get
  end

  def delete(index, type, id) do
    document_path(index, type, id) |> HTTP.delete
  end

  def document_path(index, type, id) do
    "#{index}/#{type}/#{id}"
  end
end
