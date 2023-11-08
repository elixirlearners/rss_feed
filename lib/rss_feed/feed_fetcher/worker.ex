defmodule RssFeed.FeedFetcher.Worker do
  def run(%RssFeed.Feeds.Feed{} = feed, parent_pid, http_client \\ HTTPoison) do
    result =
      feed.url
      |> http_client.get(create_headers(feed))
      |> parse()

    case result do
      {:ok, content, metadata} -> send(parent_pid, {:ok, feed, content, metadata})
      _ -> send(parent_pid, {:error, feed.url})
    end
  end

  def create_headers(feed) do
    headers = %{}

    if(feed.etag) do
      headers = Map.put(headers, "If-None-Match", feed.etag)
    end

    if feed.last_modified do
      headers = Map.put(headers, "If-Modified-Since", feed.last_modified)
    end

    headers
  end

  def extract_headers(headers) do
    enum_headers = Enum.into(headers, %{})

    %{
      etag: enum_headers["ETag"],
      last_modified: enum_headers["Last-Modified"]
    }
  end

  def parse({:ok, %HTTPoison.Response{body: body, status_code: 200, headers: headers}}) do
    metadata = extract_headers(headers)

    # Reconsider parsing the body, should probably just save it as a string in db
    case FeederEx.parse(body) do
      {:ok, content, _} -> {:ok, content, metadata}
      _ -> :error
    end
  end

  # TODO: This will handle 304 responses when the cache is up to date
  # i.e. if-modified-since (last-modified) or if-none-match (etag) headers match
  def parse({:ok, %HTTPoison.Response{status_code: 304}}) do
    # Get the cached response from db and parse it
    body = ""

    case FeederEx.parse(body) do
      {:ok, content, _} -> {:ok, content}
      _ -> :error
    end
  end

  def parse(_) do
    :error
  end
end
