defmodule Elastic.IntegrationTestCase do
  use ExUnit.CaseTemplate

  setup tags do
    Elastic.Index.delete("answer")
    Elastic.Index.delete("existence")
    Elastic.Index.refresh("answer")

    {:ok, tags}
  end
end
