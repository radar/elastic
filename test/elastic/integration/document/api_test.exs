defmodule Answer do
  @es_type "answer"
  @es_index "answer"
  use Elastic.Document.API

  defstruct [:id, :text]
end

defmodule Elastic.Document.APITest do
  use Elastic.IntegrationTestCase

  @tag integration: true
  test "puts + gets a document from the index" do
    Answer.index(1, %{text: "Hello world!"})
    answer = Answer.get(1)
    assert answer == %Answer{id: "1", text: "Hello world!"}
  end

  @tag integration: true
  test "puts + deletes a document from the index" do
    Answer.index(1, %{text: "Hello world!"})
    Answer.delete(1)
    assert match?({:error, 404, _}, Answer.raw_get(1))
  end

  @tag integration: true
  test "puts + gets a raw document from the index" do
    Answer.index(1, %{text: "Hello world!"})
    {:ok, 200, result} = Answer.raw_get(1)
    assert result == %{
      "_id" => "1",
      "_index" => "elastic_test_answer",
      "_source" => %{
        "text" => "Hello world!"
      },
      "_type" => "answer",
      "_version" => 1,
      "found" => true
    }
  end

  @tag integration: true
  test "can search for an answer" do
    Answer.index(1, %{text: "Hello world!"})
    Elastic.Index.refresh("answer")
    {:ok, 200, %{"hits" => %{"hits" => hits}}} = Answer.search(%{
      query: %{
        match: %{text: "Hello"}
      }
    })

    assert match?([%{"_source" => %{"text" => "Hello world!"}}], hits)
  end
end
