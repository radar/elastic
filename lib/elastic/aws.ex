defmodule Elastic.AWS do
  @moduledoc false
  def enabled? do
    settings()[:enabled]
  end

  def authorization_headers(method, url, headers, body) do
    AWSAuth.sign_authorization_header(
      settings().access_key_id,
      settings().secret_access_key,
      to_string(method),
      url,
      settings().region,
      "es",
      process_headers(method, headers),
      body
    )
  end

  # DELETE requests do not support headers
  defp process_headers(:delete, _), do: %{}

  defp process_headers(_method, headers) do
    for {k, v} <- headers,
        into: %{},
        do: {to_string(k), to_string(v)}
  end

  defp settings do
    Application.get_env(:elastic, :aws)
  end
end
