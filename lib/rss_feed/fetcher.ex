defmodule RssFeed.Fetcher do
  def run(url, http_client \\ HTTPoison) do
    url
    |> http_client.get()
    |> parse()
  end

  def parse({:ok, %HTTPoison.Response{body: body, status_code: 200, headers: _headers}}) do
    case FeederEx.parse(body) do
      {:ok, feed, _} -> {:ok, feed}
      _ -> :error
    end
  end

  # TODO: This will handle 304 responses when the cache is up to date
  # i.e. if-modified-since (last-modified) or if-none-match (etag) headers match
  def parse({:ok, %HTTPoison.Response{status_code: 304}}) do
    # Get the cached response from db and parse it
    body = ""

    case FeederEx.parse(body) do
      {:ok, feed, _} -> {:ok, feed}
      _ -> :error
    end
  end

  def parse(_) do
    :error
  end
end
