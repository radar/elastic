defmodule Elastic.Snapshot do
  alias Elastic.HTTP

  @moduledoc """
  This module contains functions that manipulate [ElasticSearch Snapshots](https://www.elastic.co/guide/en/elasticsearch/reference/current/modules-snapshots.html) so you
  can schedule backups and execute restores from Elixir.

  The subset that is supported (for now) is the subset that makes most use to automate: triggering snapshots, listing snapshots, cleaning up snapshots. Managing
  repositories is not part of the functionality, they have to be created with for example direct `curl` requests.
  """

  @doc """
  Creates a snapshot in the indicated repository. If name is left out, the current date/time is used. The function does not wait for the snapshot operation to complete.

  If the operation does not succeed, the function will raise an exception.
  """
  def create!(repository, name \\ nil) do
    name = if name != nil, do: name, else: synthetic_name()
    {:ok, 200, %{"accepted" => true}} = HTTP.put("/_snapshot/#{repository}/#{name}")
  end

  @doc """
  Lists all snapshots. It returns all data that ElasticSearch has on the snapshot as a straight json-to-map translation. ES doesn't document the fields, but version 5.1.1
  returns something like:

  ```
  [%{"duration_in_millis" => 372493, "end_time" => "2017-06-02T16:03:04.576Z",
  "end_time_in_millis" => 1496419384576, "failures" => [],
  "indices" => ["index1", "index2"],
  "shards" => %{"failed" => 0, "successful" => 4, "total" => 4},
  "snapshot" => "some_snapshot_name",
  "start_time" => "2017-06-02T15:56:52.083Z",
  "start_time_in_millis" => 1496419012083, "state" => "SUCCESS",
  "uuid" => "TcUJAtj-TfOTq5p-lWY6OQ", "version" => "5.1.1",
  "version_id" => 5010199}]
  ```

  If the operation does not succeed, the function will raise an exception.
  """
  def list!(repository) do
    {:ok, 200, %{"snapshots" => snapshots}} = HTTP.get("/_snapshot/#{repository}/_all")
    snapshots
  end

  @doc """
  Deletes a snapshot.

  If the operation does not succeed, the function will raise an exception.
  """
  def delete!(repository, name) do
    {:ok, 200, %{"acknowledged" => true}} = HTTP.delete("/_snapshot/#{repository}/#{name}")
  end

  defp synthetic_name do
    DateTime.utc_now()
    |> DateTime.to_string()
    |> String.replace(" ", "T")
    |> String.replace(":", "-")
    |> String.downcase()
  end
end
