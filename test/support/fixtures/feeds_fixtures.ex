defmodule RssFeed.FeedsFixtures do
  @moduledoc """
  This module defines test helpers for creating
  entities via the `RssFeed.Feeds` context.
  """

  @doc """
  Generate a unique feed url.
  """
  def unique_feed_url, do: "some url#{System.unique_integer([:positive])}"

  @doc """
  Generate a feed.
  """
  def feed_fixture(attrs \\ %{}) do
    {:ok, feed} =
      attrs
      |> Enum.into(%{
        etag: "some etag",
        last_updated: ~U[2023-11-05 10:26:00Z],
        url: unique_feed_url()
      })
      |> RssFeed.Feeds.create_feed()

    feed
  end
end
