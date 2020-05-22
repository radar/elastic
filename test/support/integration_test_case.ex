defmodule Elastic.IntegrationTestCase do
  use ExUnit.CaseTemplate

  setup tags do
    Elastic.Index.delete("answer")
    Elastic.Index.delete("existence")
    Elastic.Index.refresh("answer")

    Elastic.Index.create("answer")
    Elastic.Index.create("existence")

    Elastic.Index.delete("index_test_create")

    {:ok, tags}
  end
end
