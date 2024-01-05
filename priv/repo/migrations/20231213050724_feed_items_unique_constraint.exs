defmodule RssFeed.Repo.Migrations.FeedItemsUniqueConstraint do
  use Ecto.Migration

  def change do
    create unique_index(:feed_items, [:source_id])
  end
end
