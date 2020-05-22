defmodule Elastic.Integration.IndexTest do
  use Elastic.IntegrationTestCase
  alias Elastic.{HTTP, Index}

  @tag integration: true
  test "close/1 & open/1" do
    Answer.index(1, %{text: "Hello world!"})

    cat_result = get_index_response(HTTP.get("_cat/indices?format=json"), Index.name("answer"))
    assert %{"status" => "open"} = cat_result

    Index.close("answer")

    cat_result = get_index_response(HTTP.get("_cat/indices?format=json"), Index.name("answer"))
    assert %{"status" => "close"} = cat_result

    Index.open("answer")

    cat_result = get_index_response(HTTP.get("_cat/indices?format=json"), Index.name("answer"))
    assert %{"status" => "open"} = cat_result
  end

  @tag integration: true
  test "create/1" do
    result_create = Index.create("index_test_create")

    assert {:ok, 200, _} = result_create
  end

  @tag integration: true
  test "create/2" do
    result_create = Index.create("index_test_create", %{mappings: %{}})

    assert {:ok, 200, _} = result_create
  end

  defp get_index_response({:ok, 200, indices}, name) do
    indices
    |> Enum.find(&(&1["index"] == name))
  end
end
