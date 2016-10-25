defmodule Elastic.Query do
  @moduledoc false

  defstruct index: nil, body: %{}

  def build(index, body) do
    %Elastic.Query{index: index, body: body}
  end
end
