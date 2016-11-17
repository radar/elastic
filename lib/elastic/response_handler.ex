defmodule Elastic.ResponseHandler do
  @moduledoc false

  def process(%{body: body, status_code: status_code}) when status_code in 400..599 do
    {:error, status_code, decode_body(body)}
  end

  def process(%{body: body, status_code: status_code}) do
    {:ok, status_code, decode_body(body)}
  end

  def process(%HTTPotion.ErrorResponse{message: "econnrefused"}) do
    {:error, 0, %{"error" => "Could not connect to Elasticsearch: connection refused (econnrefused)"}}
  end

  def process(%HTTPotion.ErrorResponse{message: "nxdomain"}) do
    {:error, 0, %{"error" => "Could not connect to Elasticsearch: could not resolve address (nxdomain)"}}
  end

  defp decode_body("") do
    ""
  end

  defp decode_body(body) do
    {:ok, decoded_body} = Poison.decode(body)
    decoded_body
  end
end
