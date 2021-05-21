defmodule Elastic.Document.APITest do
  alias Elastic.Index
  use Elastic.IntegrationTestCase

  @tag integration: true
  test "puts + gets a document from the index" do
    Answer.index(1, %{text: "Hello world!"})
    answer = Answer.get(1)
    assert answer == %Answer{id: "1", text: "Hello world!"}
  end

  @tag integration: true
  test "puts + updates a document in the index" do
    Answer.index(1, %{text: "Hello world!"})
    {:ok, 200, _} = Answer.update(1, %{comments: 5})
    answer = Answer.get(1)
    assert answer == %Answer{id: "1", text: "Hello world!", comments: 5}
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

    assert result["found"]
    assert result["_id"] == "1"
    assert result["_index"] == "elastic_test_answer"
    assert result["_type"] == "answer"

    assert result["_source"] == %{
             "text" => "Hello world!"
           }

    assert result["_version"] == 1
  end

  @tag integration: true
  test "can search for a raw answer" do
    Answer.index(1, %{text: "Hello world!"})
    Elastic.Index.refresh("answer")

    {:ok, 200, %{"hits" => %{"hits" => hits}}} =
      Answer.raw_search(%{
        query: %{
          match: %{text: "Hello"}
        }
      })

    assert match?([%{"_source" => %{"text" => "Hello world!"}}], hits)
  end

  @tag integration: true
  test "can search for an answer" do
    Answer.index(1, %{text: "Hello world!"})
    Elastic.Index.refresh("answer")

    answers =
      Answer.search(%{
        query: %{
          match: %{text: "Hello"}
        }
      })

    assert answers == [%Answer{id: "1", text: "Hello world!"}]
  end

  @tag integration: true
  test "can search for a question with explicit index" do
    Question.index(2, %{text: "Goodbye world?"}, "question")
    Elastic.Index.refresh("question")

    questions =
      Question.search(
        %{
          query: %{
            match: %{text: "Goodbye"}
          }
        },
        "question"
      )

    assert questions == [%Question{id: "2", text: "Goodbye world?"}]
  end

  @tag integration: true
  test "can search for a raw question with explicit index" do
    Question.index(1, %{text: "Raw world!"}, "raw_index")
    Elastic.Index.refresh("raw_index")

    {:ok, 200, %{"hits" => %{"hits" => hits}}} =
      Question.raw_search(
        %{
          query: %{
            match: %{text: "Raw"}
          }
        },
        "raw_index"
      )

    assert match?([%{"_source" => %{"text" => "Raw world!"}}], hits)
  end

  @tag integration: true
  test "puts + gets a document from explicit index" do
    Question.index(1, %{text: "Hello world!"}, "some_index")
    answer = Question.get(1, "some_index")
    assert answer == %Question{id: "1", text: "Hello world!"}
  end

  @tag integration: true
  test "puts + updates a document in explicit index" do
    Question.index(1, %{text: "Hello world!"}, "some_index")
    {:ok, 200, _} = Question.update(1, %{comments: 5}, "some_index")
    answer = Question.get(1, "some_index")
    assert answer == %Question{id: "1", text: "Hello world!", comments: 5}
  end

  @tag integration: true
  test "puts + deletes a document from explicit index" do
    Question.index(1, %{text: "Hello world!"}, "some_index")
    Question.delete(1, "some_index")
    assert match?({:error, 404, _}, Question.raw_get(1, "some_index"))
  end

  @tag integration: true
  test "checks if the index exists" do
    Index.delete("answer")
    refute Answer.index_exists?()

    Answer.index(1, %{text: "Hello world!"})

    assert Answer.index_exists?()
  end
end
