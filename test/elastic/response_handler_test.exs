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

  test "handles a econnrefused" do
    response = ResponseHandler.process(%HTTPotion.ErrorResponse{message: "econnrefused"})
    assert {:error, 0, %{"error" => "Could not connect to Elasticsearch: connection refused (econnrefused)"}} == response
  end

  test "handles a nxdomain" do
    response = ResponseHandler.process(%HTTPotion.ErrorResponse{message: "nxdomain"})
    assert {:error, 0, %{"error" => "Could not connect to Elasticsearch: could not resolve address (nxdomain)"}} == response
  end

  test "handles a connection_closed" do
    response = ResponseHandler.process(%HTTPotion.ErrorResponse{message: "connection_closed"})
    assert {:error, 0, %{"error" => "Could not connect to Elasticsearch: connection closed (connection_closed)"}} == response
  end

  test "handles a req_timedout" do
    response = ResponseHandler.process(%HTTPotion.ErrorResponse{message: "req_timedout"})
    assert {:error, 0, %{"error" => "Could not connect to Elasticsearch: request timed out (req_timedout)"}} == response
  end
end
