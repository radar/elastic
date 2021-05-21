ExUnit.start(exclude: [integration: true])

defmodule Answer do
  @es_type "answer"
  @es_index "answer"
  use Elastic.Document.API

  defstruct [:id, :text, :comments]
end

defmodule Question do
  @es_type "question"
  @es_index "N/A"
  use Elastic.Document.API

  defstruct [:id, :text, :comments]
end

defmodule ElasticTestUtil do
  def with_application_env(app, key, new, context) do
    old = Application.get_env(app, key)
    Application.put_env(app, key, new)

    try do
      context.()
    after
      Application.put_env(app, key, old)
    end
  end
end
