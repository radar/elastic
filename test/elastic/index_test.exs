defmodule Elastic.IndexTest do
  use ExUnit.Case

  test "build_index uses the index_prefix" do
    assert Elastic.Index.name("answer") == "elastic_test_answer"
  end
end
