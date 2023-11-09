defmodule RssFeed.FeedItemsFixtures do
  @moduledoc """
  This module defines test helpers for creating
  entities via the `RssFeed.FeedItems` context.
  """

  @doc """
  Generate a feed_item.
  """
  def feed_item_fixture(attrs \\ %{}) do
    {:ok, feed_item} =
      attrs
      |> Enum.into(%{
        author: "some author",
        categories: "some categories",
        duration: "some duration",
        enclosure: "some enclosure",
        image: "some image",
        link: "some link",
        subtitle: "some subtitle",
        summary: "some summary",
        title: "some title",
        updated: "some updated"
      })
      |> RssFeed.FeedItems.create_feed_item()

    feed_item
  end
end
