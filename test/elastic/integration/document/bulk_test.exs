defmodule Elastic.Document.BulkTest do
  use Elastic.IntegrationTestCase

  @tag integration: true
  test "bulk creates answers with ids" do
    Elastic.Bulk.create([
      {index, "answer", 1, %{text: "this is an answer"}},
      {index, "answer", 2, %{text: "and this is one too"}}
    ])

    answer = Answer.get(1)
    assert answer == %Answer{id: "1", text: "this is an answer"}
    assert Answer.get(2)
  end

  test "bulk creates answers without ids" do
    Elastic.Bulk.create([
      {index, "answer", nil, %{text: "hello world"}},
      {index, "answer", nil, %{text: "world hello"}}
    ])

    Elastic.Index.refresh("answer")

    answers = Answer.search(%{
      query: %{
        match: %{text: "world"}
      },
    })

    assert Enum.count(answers) == 2
  end

  def index do
    Elastic.Index.name("answer")
  end
end
