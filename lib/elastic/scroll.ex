defmodule Elastic.Scroll do
  alias Elastic.HTTP
  alias Elastic.Index
  @scroll_endpoint "_search/scroll"

  def start(%{index: index, body: body, size: size, keepalive: keepalive}) do
    body = body |> Map.merge(%{size: size})
    HTTP.get("#{Index.name(index)}/_search?scroll=#{keepalive}", body: body)
  end

  def next(%{body: body, scroll_id: scroll_id, keepalive: keepalive}) do
    body = body |> Map.merge(%{scroll_id: scroll_id, scroll: keepalive})
    HTTP.get(@scroll_endpoint, body: body)
  end

  def clear(scroll_id) do
    HTTP.delete(@scroll_endpoint, body: %{scroll_id: scroll_id})
  end
end
