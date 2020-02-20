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
    body = Keyword.get(options, :body, "") <> "\n"
    options = Keyword.put(options, :body, body)
    request(:post, "_bulk", options)
  end

  defp base_url do
    Elastic.base_url() || "http://localhost:9200"
  end

  defp request(method, url, options) do
    body = Keyword.get(options, :body, []) |> encode_body
    timeout = Application.get_env(:elastic, :timeout, 30_000)
    url = URI.merge(base_url(), url)

    options =
      options
      |> Keyword.put_new(:headers, Keyword.new())
      |> Keyword.put(:body, body)
      |> Keyword.put(:timeout, timeout)
      |> add_content_type_header
      |> add_aws_header(method, url, body)
      |> add_basic_auth

    apply(HTTPotion, method, [url, options]) |> process_response
  end

  defp add_content_type_header(options) do
    headers = Keyword.put(options[:headers], :"Content-Type", "application/json")
    Keyword.put(options, :headers, headers)
  end

  def add_aws_header(options, method, url, body) do
    if AWS.enabled?() do
      headers =
        AWS.authorization_headers(
          method,
          url,
          options[:headers],
          body
        )
        |> Enum.reduce(options[:headers], fn {header, value}, headers ->
          Keyword.put(headers, String.to_atom(header), value)
        end)

      Keyword.put(options, :headers, headers)
    else
      options
    end
  end

  def add_basic_auth(options) do
    basic_auth = Keyword.get(options, :basic_auth, Elastic.basic_auth())
    Keyword.put(options, :basic_auth, basic_auth)
  end

  defp process_response(response) do
    ResponseHandler.process(response)
  end

  defp encode_body(body) when is_binary(body) do
    body
  end

  defp encode_body(body) when is_map(body) and body != %{} do
    {:ok, encoded_body} = Jason.encode(body)
    encoded_body
  end

  defp encode_body(_body) do
    ""
  end
end
