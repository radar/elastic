defmodule Elastic.HTTP do
  alias Elastic.AWS
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
  Makes a request using the GET HTTP method, and can take a body.

  ```
  Elastic.HTTP.get("/answer/_search", body: %{query: ...})
  ```

  """
  def get(url, options \\ []) do
    request(:get, url, options)
  end

  @doc """
  Makes a request using the POST HTTP method, and can take a body.
  """
  def post(url, options \\ []) do
    request(:post, url, options)
  end

  @doc """
  Makes a request using the PUT HTTP method:

  ```
  Elastic.HTTP.put("/answers/answer/1", body: %{
    text: "I like using Elastic Search"
  })
  ```
  """
  def put(url, options \\ []) do
    request(:put, url, options)
  end

  @doc """
  Makes a request using the DELETE HTTP method:

  ```
  Elastic.HTTP.delete("/answers/answer/1")
  ```
  """
  def delete(url, options \\ []) do
    request(:delete, url, options)
  end

  @doc """
  Makes a request using the HEAD HTTP method:

  ```
  Elastic.HTTP.head("/answers")
  ```
  """
  def head(url, options \\ []) do
    request(:head, url, options)
  end

  def bulk(options) do
    headers = Keyword.get(options, :headers, [])
    body = Keyword.get(options, :body, "") <> "\n"
    options = Keyword.put(options, :body, body)
    url = URI.merge(base_url(), "_bulk")
    HTTPotion.post(url, options) |> process_response
  end

  defp base_url do
    Elastic.base_url || "http://localhost:9200"
  end

  defp request(method, url, options) do
    body = Keyword.get(options, :body, []) |> encode_body
    headers = Keyword.get(options, :headers, [])
    url = URI.merge(base_url(), url)

    headers = build_auth_header(method, url, headers, body)

    options = options
    |> Keyword.put(:headers, headers)
    |> Keyword.put(:body, body)
    |> Keyword.put(:timeout, 30_000)

    apply(HTTPotion, method, [url, options]) |> process_response
  end

  defp process_response(response) do
    ResponseHandler.process(response)
  end

  defp encode_body([]) do
    []
  end

  defp encode_body(body) do
    {:ok, encoded_body} = Poison.encode(body)
    encoded_body
  end

  defp build_auth_header(method, url, headers, body) do
    if AWS.enabled?,
      do: AWS.sign_authorization_headers(method, url, headers, body),
      else: headers
  end
end
