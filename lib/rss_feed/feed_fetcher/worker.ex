defmodule RssFeed.FeedFetcher.Worker do
  def run(%RssFeed.Feeds.Feed{url: url}, parent_pid, http_client \\ HTTPoison) do
    result =
      url
      |> http_client.get()
      |> parse()

    case result do
      {:ok, feed, metadata} -> send(parent_pid, {:ok, feed, metadata})
      _ -> send(parent_pid, {:error, url})
    end
  end

  def parse({:ok, %HTTPoison.Response{body: body, status_code: 200, headers: headers}}) do
    IO.inspect(headers)

    enum_headers = Enum.into(headers, %{})

    metadata = %{
      etag: enum_headers["ETag"],
      last_modified: enum_headers["Last-Modified"]
    }

    case FeederEx.parse(body) do
      {:ok, feed, _} -> {:ok, feed, metadata: metadata}
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
