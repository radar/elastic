defmodule Elastic.Integration.HTTPTest do
  use Elastic.IntegrationTestCase
  alias Elastic.{HTTP, Index}

  setup do
    Answer.index(1, %{text: "Hello Earth!"})
    Elastic.Index.refresh("answer")
    :ok
  end

  # Regression test for #20 / #21
  @tag integration: true
  test "multisearch with ndjson string body" do
    ndjson_string = """
    {"index" : "#{Index.name("answer")}"}
    {"query" : {"match_all" : {}}, "from" : 0, "size" : 10}
    """

    {:ok, 200, data} = HTTP.get("/_msearch", body: ndjson_string)
    %{"responses" => [%{"hits" => %{"hits" => [doc]}}]} = data

    assert doc["_id"] == "1"
    assert doc["_source"] == %{"text" => "Hello Earth!"}
  end
end
