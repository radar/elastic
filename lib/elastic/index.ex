defmodule Elastic.Index do
  @moduledoc false

  alias Elastic.HTTP

  def name(index) do
    [index_prefix, mix_env, index]
    |> Enum.reject(&(&1 == nil))
    |> Enum.join("_")
  end

  def delete(index) do
    HTTP.delete(name(index))
  end

  def refresh(index) do
    HTTP.post("#{name(index)}/_refresh")
  end

  def search(index, query) do
    HTTP.get("#{name(index)}/_search", body: query)
  end

  def count(index, query) do
    HTTP.get("#{name(index)}/_count", body: query)
  end

  defp index_prefix do
    Application.get_env(:elastic, :index_prefix)
  end

  defp mix_env do
    if Application.get_env(:elastic, :use_mix_env),
      do: Mix.env,
      else: nil
  end
end
