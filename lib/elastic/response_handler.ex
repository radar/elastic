defmodule Elastic.ResponseHandler do
  @moduledoc false

  def process(%{body: body, status_code: status_code}) when status_code in 400..599 do
    {:error, status_code, decode_body(body)}
  end

  def process(%{body: body, status_code: status_code}) do
    {:ok, status_code, decode_body(body)}
  end

  defp decode_body(body) do
    {:ok, decoded_body} = Poison.decode(body)
    decoded_body
  end
end
