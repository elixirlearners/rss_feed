defmodule RssFeed.FeedItems do
  @moduledoc """
  The FeedItems context.
  """

  import Ecto.Query, warn: false
  alias RssFeed.Repo

  alias RssFeed.FeedItems.FeedItem

  @doc """
  Returns the list of feed_items.

  ## Examples

      iex> list_feed_items()
      [%FeedItem{}, ...]

  """
  def list_feed_items do
    Repo.all(FeedItem)
  end

  @doc """
  Gets a single feed_item.

  Raises `Ecto.NoResultsError` if the Feed item does not exist.

  ## Examples

      iex> get_feed_item!(123)
      %FeedItem{}

      iex> get_feed_item!(456)
      ** (Ecto.NoResultsError)

  """
  def get_feed_item!(id), do: Repo.get!(FeedItem, id)

  @doc """
  Creates a feed_item.

  ## Examples

      iex> create_feed_item(%{field: value})
      {:ok, %FeedItem{}}

      iex> create_feed_item(%{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def create_feed_item(attrs \\ %{}) do
    %FeedItem{}
    |> FeedItem.changeset(attrs)
    |> Repo.insert()
  end

  def upsert_feed_item(%FeedItem{} = feed_item) do
    feed_item
    |> Repo.insert(
      on_conflict: {:replace_all_except, [:id]},
      conflict_target: [:source_id]
    )
  end

  def build_feed_item_associations(feed_struct, entries) do
    if entries do
      entries
      |> Enum.map(fn entry ->
        Ecto.build_assoc(
          feed_struct,
          :entries,
          # Remove attrs temporarily, only
          Map.drop(entry, [:enclosure, :duration, :categories])
        )
      end)
    end
  end

  @doc """
  Updates a feed_item.

  ## Examples

      iex> update_feed_item(feed_item, %{field: new_value})
      {:ok, %FeedItem{}}

      iex> update_feed_item(feed_item, %{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def update_feed_item(%FeedItem{} = feed_item, attrs) do
    feed_item
    |> FeedItem.changeset(attrs)
    |> Repo.update()
  end

  @doc """
  Deletes a feed_item.

  ## Examples

      iex> delete_feed_item(feed_item)
      {:ok, %FeedItem{}}

      iex> delete_feed_item(feed_item)
      {:error, %Ecto.Changeset{}}

  """
  def delete_feed_item(%FeedItem{} = feed_item) do
    Repo.delete(feed_item)
  end

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking feed_item changes.

  ## Examples

      iex> change_feed_item(feed_item)
      %Ecto.Changeset{data: %FeedItem{}}

  """
  def change_feed_item(%FeedItem{} = feed_item, attrs \\ %{}) do
    FeedItem.changeset(feed_item, attrs)
  end
end
