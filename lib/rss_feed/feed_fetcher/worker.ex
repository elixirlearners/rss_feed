defmodule RssFeed.FeedFetcher.Worker do
  require Logger

  def run(%RssFeed.Feeds.Feed{} = feed, parent_pid, http_client \\ HTTPoison) do
    result =
      feed.url
      |> http_client.get(make_headers(feed))
      |> parse()

    case result do
      {:ok, content, metadata} when content != nil and metadata != nil ->
        map_entries =
          Enum.map(content.entries, fn entry ->
            entry
            |> Map.put_new(:source_id, Map.get(entry, :id))
            |> Map.put_new(:feed_id, Map.get(feed, :id))
            |> Map.delete(:id)
            |> Map.from_struct()
          end)

        map_data =
          content
          |> Map.put(:id, Map.get(feed, :id))
          |> Map.replace(:entries, map_entries)
          |> Map.from_struct()

        send(parent_pid, {:ok, feed, Map.merge(map_data, metadata)})

      {:ok, _, _} ->
        send(parent_pid, {:ok, feed, nil})

      _ ->
        send(parent_pid, {:error, feed.url})
    end
  end

  def make_headers(feed) do
    headers = %{}

    case {Map.get(feed, :etag, nil), Map.get(feed, :last_modified, nil)} do
      {etag, last_modified} when last_modified != nil and etag != nil ->
        Map.put(headers, "If-Modified-Since", last_modified)

      {etag, nil} ->
        Map.put(headers, "If-None-Match", etag)

      {nil, last_modified} ->
        Map.put(headers, "If-Modified-Since", last_modified)

      _ ->
        headers
    end
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
    {:ok, nil, nil}
  end

  def parse(err) do
    Logger.alert("RSSFeed.FeedFetcher.Worker Error: #{inspect(err)}")
    :error
  end
end
