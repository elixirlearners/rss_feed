defmodule RssFeed.Feeds do
  @moduledoc """
  The Feeds context.
  """

  import Ecto.Query, warn: false
  alias RssFeed.Repo
  alias RssFeed.Feeds.Feed

  # 1 hour in seconds
  @time_limit 60 * 60

  @doc """
  Returns the list of feeds.

  ## Examples

      iex> list_feeds()
      [%Feed{}, ...]

  """
  def list_feeds do
    Repo.all(Feed)
  end

  def list_all_due_for_update do
    {:ok, now} = DateTime.now("Etc/UTC")
    overdue = DateTime.add(now, -@time_limit)

    from(
      f in Feed,
      where: f.updated_at < ^overdue,
      select: f
    )
    |> Repo.all()
  end

  @doc """
  Updates the cache headers needed for a feed
  """
  def update_cache_metadata(%Feed{} = feed, attrs \\ %{}) do
    feed
    |> Feed.changeset_update_metadata(attrs)
    # force update timestamp regardless if there is a change or not
    |> Repo.update(force: true)
  end

  @doc """
  Gets a single feed.

  Raises `Ecto.NoResultsError` if the Feed does not exist.

  ## Examples

      iex> get_feed!(123)
      %Feed{}

      iex> get_feed!(456)
      ** (Ecto.NoResultsError)

  """
  def get_feed!(id), do: Repo.get!(Feed, id)

  @doc """
  Creates a feed.

  ## Examples

      iex> create_feed(%{field: value})
      {:ok, %Feed{}}

      iex> create_feed(%{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def create_feed(attrs \\ %{}) do
    %Feed{}
    |> Feed.changeset(attrs)
    |> Repo.insert()
  end

  @doc """
  Updates a feed.

  ## Examples

      iex> update_feed(feed, %{field: new_value})
      {:ok, %Feed{}}

      iex> update_feed(feed, %{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def update_feed(%Feed{} = feed, attrs) do
    feed
    |> Feed.changeset(attrs)
    |> Repo.update()
  end

  @doc """
  Deletes a feed.

  ## Examples

      iex> delete_feed(feed)
      {:ok, %Feed{}}

      iex> delete_feed(feed)
      {:error, %Ecto.Changeset{}}

  """
  def delete_feed(%Feed{} = feed) do
    Repo.delete(feed)
  end

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking feed changes.

  ## Examples

      iex> change_feed(feed)
      %Ecto.Changeset{data: %Feed{}}

  """
  def change_feed(%Feed{} = feed, attrs \\ %{}) do
    Feed.changeset(feed, attrs)
  end
end
