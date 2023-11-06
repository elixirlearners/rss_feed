defmodule RssFeed.FeedsTest do
  use RssFeed.DataCase

  alias RssFeed.Feeds

  describe "feeds" do
    alias RssFeed.Feeds.Feed

    import RssFeed.FeedsFixtures

    @invalid_attrs %{url: nil, etag: nil, last_updated: nil}

    test "list_feeds/0 returns all feeds" do
      feed = feed_fixture()
      assert Feeds.list_feeds() == [feed]
    end

    test "get_feed!/1 returns the feed with given id" do
      feed = feed_fixture()
      assert Feeds.get_feed!(feed.id) == feed
    end

    test "create_feed/1 with valid data creates a feed" do
      valid_attrs = %{url: "some url", etag: "some etag", last_updated: ~U[2023-11-05 10:26:00Z]}

      assert {:ok, %Feed{} = feed} = Feeds.create_feed(valid_attrs)
      assert feed.url == "some url"
      assert feed.etag == "some etag"
      assert feed.last_updated == ~U[2023-11-05 10:26:00Z]
    end

    test "create_feed/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Feeds.create_feed(@invalid_attrs)
    end

    test "update_feed/2 with valid data updates the feed" do
      feed = feed_fixture()
      update_attrs = %{url: "some updated url", etag: "some updated etag", last_updated: ~U[2023-11-06 10:26:00Z]}

      assert {:ok, %Feed{} = feed} = Feeds.update_feed(feed, update_attrs)
      assert feed.url == "some updated url"
      assert feed.etag == "some updated etag"
      assert feed.last_updated == ~U[2023-11-06 10:26:00Z]
    end

    test "update_feed/2 with invalid data returns error changeset" do
      feed = feed_fixture()
      assert {:error, %Ecto.Changeset{}} = Feeds.update_feed(feed, @invalid_attrs)
      assert feed == Feeds.get_feed!(feed.id)
    end

    test "delete_feed/1 deletes the feed" do
      feed = feed_fixture()
      assert {:ok, %Feed{}} = Feeds.delete_feed(feed)
      assert_raise Ecto.NoResultsError, fn -> Feeds.get_feed!(feed.id) end
    end

    test "change_feed/1 returns a feed changeset" do
      feed = feed_fixture()
      assert %Ecto.Changeset{} = Feeds.change_feed(feed)
    end
  end
end
