defmodule Elastic.IndexTest do
  use ExUnit.Case
  import ElasticTestUtil

  test "build_index uses the index_prefix" do
    assert Elastic.Index.name("answer") == "elastic_test_answer"
  end

  test "Index.name/1 rejects empty strings" do
    with_application_env(:elastic, :index_prefix, "", fn ->
      assert Elastic.Index.name("answer") == "test_answer"
    end)
  end
end
