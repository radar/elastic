defmodule Elastic.HTTP do
  @moduledoc ~S"""
  Used to make raw calls to Elastic Search.

  Each function returns a tuple indicating whether or not the request
  succeeded or failed (`:ok` or `:error`), the status code of the response,
  and then the processed body of the response.

  For example, a request like this:

  ```elixir
    Elastic.HTTP.get("/answer/_search")
  ```

  Would return a response like this:

  ```
    {:ok, 200,
     %{"_shards" => %{"failed" => 0, "successful" => 5, "total" => 5},
       "hits" => %{"hits" => [%{"_id" => "1", "_index" => "answer", "_score" => 1.0,
            "_source" => %{"text" => "I like using Elastic Search"}, "_type" => "answer"}],
         "max_score" => 1.0, "total" => 1}, "timed_out" => false, "took" => 7}}
  ```
  """

  alias Elastic.ResponseHandler

  @doc """
  Makes a request using the GET HTTP method.
  """
  def get(url) do
    response = HTTPotion.get(build_url(url))
    process_response(response)
  end

  @doc """
  Makes a request using the GET HTTP method, and can take a body.

  ```
  Elastic.HTTP.get("/answer/_search", body: %{query: ...})
  ```

  """
  def get(url, body: body) do
    encoded_body = encode_body(body)
    response = HTTPotion.get(build_url(url), body: encoded_body)
    process_response(response)
  end

  @doc """
  Makes a request using the POST HTTP method.
  """
  def post(url) do
    response = HTTPotion.post(build_url(url))
    process_response(response)
  end

  @doc """
  Makes a request using the POST HTTP method, and can take a body.
  """
  def post(url, body: body) do
    encoded_body = encode_body(body)
    response = HTTPotion.post(build_url(url), body: encoded_body)
    process_response(response)
  end

  @doc """
  Makes a request using the PUT HTTP method:

  ```
  Elastic.HTTP.put("/answers/answer/1", body: %{
    text: "I like using Elastic Search"
  })
  ```
  """
  def put(url, body: body) do
    encoded_body = encode_body(body)
    response = HTTPotion.put(build_url(url), body: encoded_body)
    process_response(response)
  end

  @doc """
  Makes a request using the DELETE HTTP method:

  ```
  Elastic.HTTP.delete("/answers/answer/1")
  ```
  """
  def delete(url) do
    response = HTTPotion.delete(build_url(url))
    process_response(response)
  end

  defp base_url do
    Application.get_env(:elastic, :base_url) || "http://localhost:9200"
  end

  defp process_response(response) do
    ResponseHandler.process(response)
  end

  defp encode_body(body) do
    {:ok, encoded_body} = Poison.encode(body)
    encoded_body
  end

  defp build_url(url) do
    URI.merge(base_url, url)
  end
end
