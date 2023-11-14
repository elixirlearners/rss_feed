defmodule RssFeed.FeedItemsTest do
  use RssFeed.DataCase

  alias RssFeed.FeedItems

  describe "feed_items" do
    alias RssFeed.FeedItems.FeedItem

    import RssFeed.FeedItemsFixtures

    @invalid_attrs %{
      link: nil,
      title: nil,
      author: nil,
      image: nil,
      categories: nil,
      duration: nil,
      enclosure: nil,
      subtitle: nil,
      summary: nil,
      updated: nil
    }

    test "list_feed_items/0 returns all feed_items" do
      feed_item = feed_item_fixture()
      assert FeedItems.list_feed_items() == [feed_item]
    end

    test "get_feed_item!/1 returns the feed_item with given id" do
      feed_item = feed_item_fixture()
      assert FeedItems.get_feed_item!(feed_item.id) == feed_item
    end

    test "create_feed_item/1 with valid data creates a feed_item" do
      valid_attrs = %{
        link: "some link",
        title: "some title",
        author: "some author",
        image: "some image",
        categories: "some categories",
        duration: "some duration",
        enclosure: "some enclosure",
        subtitle: "some subtitle",
        summary: "some summary",
        updated: "some updated",
        source_id: "some source_id"
      }

      assert {:ok, %FeedItem{} = feed_item} = FeedItems.create_feed_item(valid_attrs)
      assert feed_item.link == "some link"
      assert feed_item.title == "some title"
      assert feed_item.author == "some author"
      assert feed_item.image == "some image"
      # TODO Uncomment when this is updated
      # assert feed_item.categories == "some categories"
      # assert feed_item.duration == "some duration"
      # assert feed_item.enclosure == "some enclosure"
      assert feed_item.subtitle == "some subtitle"
      assert feed_item.summary == "some summary"
      assert feed_item.updated == "some updated"
      assert feed_item.source_id == "some source_id"
    end

    test "create_feed_item/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = FeedItems.create_feed_item(@invalid_attrs)
    end

    test "update_feed_item/2 with valid data updates the feed_item" do
      feed_item = feed_item_fixture()

      update_attrs = %{
        link: "some updated link",
        title: "some updated title",
        author: "some updated author",
        image: "some updated image",
        categories: "some updated categories",
        duration: "some updated duration",
        enclosure: "some updated enclosure",
        subtitle: "some updated subtitle",
        summary: "some updated summary",
        updated: "some updated updated"
      }

      assert {:ok, %FeedItem{} = feed_item} = FeedItems.update_feed_item(feed_item, update_attrs)
      assert feed_item.link == "some updated link"
      assert feed_item.title == "some updated title"
      assert feed_item.author == "some updated author"
      assert feed_item.image == "some updated image"
      # TODO Uncomment when this is updated
      # assert feed_item.categories == "some updated categories"
      # assert feed_item.duration == "some updated duration"
      # assert feed_item.enclosure == "some updated enclosure"
      assert feed_item.subtitle == "some updated subtitle"
      assert feed_item.summary == "some updated summary"
      assert feed_item.updated == "some updated updated"
    end

    test "update_feed_item/2 with invalid data returns error changeset" do
      feed_item = feed_item_fixture()
      assert {:error, %Ecto.Changeset{}} = FeedItems.update_feed_item(feed_item, @invalid_attrs)
      assert feed_item == FeedItems.get_feed_item!(feed_item.id)
    end

    test "delete_feed_item/1 deletes the feed_item" do
      feed_item = feed_item_fixture()
      assert {:ok, %FeedItem{}} = FeedItems.delete_feed_item(feed_item)
      assert_raise Ecto.NoResultsError, fn -> FeedItems.get_feed_item!(feed_item.id) end
    end

    test "change_feed_item/1 returns a feed_item changeset" do
      feed_item = feed_item_fixture()
      assert %Ecto.Changeset{} = FeedItems.change_feed_item(feed_item)
    end
  end
end
