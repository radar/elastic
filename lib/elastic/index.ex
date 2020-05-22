defmodule Elastic.Index do
  alias Elastic.HTTP
  alias Elastic.Query

  @moduledoc ~S"""
  Collection of functions to work with indices.
  """

  @doc """
  Helper function for getting the name of an index combined with the
  `index_prefix` and `mix_env` configuration.
  """
  def name(index) do
    [index_prefix(), mix_env(), index]
    |> Enum.reject(&(&1 == nil || &1 == ""))
    |> Enum.join("_")
  end

  @doc """
  Creates the specified index.
  If you've configured `index_prefix` and `use_mix_env` for Elastic, it will use those.

  ## Examples

  ```elixir
  # With index_prefix set to 'elastic'
  # And with `use_mix_env` set to `true`
  # This will create the `elastic_dev_answer` index
  Elastic.Index.create("answer")
  ```
  """

  def create(index) do
    HTTP.put(name(index))
  end

  @doc """
  Creates the specified index with optional configuration parameters like settings,
  mappings, aliases (see the ES Indices API documentation for information on what
  you can pass).
  If you've configured `index_prefix` and `use_mix_env` for Elastic, it will use those.

  ## Examples

  ```elixir
  # With index_prefix set to 'elastic'
  # And with `use_mix_env` set to `true`
  # This will create the `elastic_dev_answer` index
  Elastic.Index.create("answer", %{settings: {number_of_shards: 2}})
  ```
  """

  def create(index, parameters) do
    HTTP.put(name(index), body: parameters)
  end

  @doc """
  Deletes the specified index.
  If you've configured `index_prefix` and `use_mix_env` for Elastic, it will use those.

  ## Examples

  ```elixir
  # With index_prefix set to 'elastic'
  # And with `use_mix_env` set to `true`
  # This will delete the `elastic_dev_answer` index
  Elastic.Index.delete("answer")
  ```

  """
  def delete(index) do
    index |> name |> HTTP.delete()
  end

  @doc """
  Refreshes the specified index by issuing a [refresh HTTP call](https://www.elastic.co/guide/en/elasticsearch/reference/current/indices-refresh.html).
  """
  def refresh(index) do
    HTTP.post("#{name(index)}/_refresh")
  end

  @doc """
  Checks if the specified index exists.
  The index name will be automatically prefixed as per this package's configuration.
  """
  def exists?(index) do
    {_, status, _} = index |> name |> HTTP.head()
    status == 200
  end

  @doc """
  Opens the specified index.
  """
  def open(index) do
    HTTP.post("#{name(index)}/_open")
  end

  @doc """
  Closes the specified index.
  """
  def close(index) do
    HTTP.post("#{name(index)}/_close")
  end

  @doc false
  def search(%Query{index: index, body: body}) do
    HTTP.get("#{name(index)}/_search", body: body)
  end

  @doc false
  def count(%Query{index: index, body: body}) do
    HTTP.get("#{name(index)}/_count", body: body)
  end

  defp index_prefix do
    Application.get_env(:elastic, :index_prefix)
  end

  defp mix_env do
    if Application.get_env(:elastic, :use_mix_env),
      do: Mix.env(),
      else: nil
  end
end
