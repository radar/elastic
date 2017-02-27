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
