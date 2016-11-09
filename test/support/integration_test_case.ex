defmodule Elastic.IntegrationTestCase do
  use ExUnit.CaseTemplate

  setup tags do
    Elastic.Index.delete("answer")
    Elastic.Index.refresh("answer")

    {:ok, tags}
  end
end
