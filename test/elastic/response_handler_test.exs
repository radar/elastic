defmodule Elastic.ResponseHandlerTest do
  use ExUnit.Case
  alias Elastic.ResponseHandler

  test "handles a 200 response" do
    {:ok, body} = Poison.encode(%{count: 1})
    response = ResponseHandler.process(%{body: body, status_code: 200})
    assert {:ok, 200, %{"count" => 1}} == response
  end

  test "handles a 404 response" do
    {:ok, body} = Poison.encode(%{error: "no such index"})
    response = ResponseHandler.process(%{body: body, status_code: 404})
    assert {:error, 404, %{"error" => "no such index"}} == response
  end
end
