defmodule RssFeed.Fetcher do
  def run(url, http_client \\ HTTPoison) do
    url
    |> http_client.get()
    |> parse()
  end

  def parse({:ok, %HTTPoison.Response{body: body, status_code: 200, headers: _headers}}) do
    # TODO: We will also need to use the headers in the response to extract ETag and last-modified values
    case FeederEx.parse(body) do
      {:ok, feed, _} -> {:ok, feed}
      _ -> :error
    end
  end

  def parse(_) do
    :error
  end
end
