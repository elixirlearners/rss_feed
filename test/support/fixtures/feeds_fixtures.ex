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
      |> Enum.into(%{url: unique_feed_url()})
      |> RssFeed.Feeds.create_feed()

    feed
  end
end
