defmodule RssFeed.Repo.Migrations.CreateFeedItems do
  use Ecto.Migration

  def change do
    create table(:feed_items, primary_key: false) do
      add :id, :binary_id, primary_key: true
      add :author, :string
      add :categories, :string
      add :duration, :string
      add :enclosure, :text
      add :image, :text
      add :link, :text
      add :subtitle, :text
      add :summary, :text
      add :title, :text
      add :updated, :string
      add :feed_id, references(:feeds, on_delete: :nothing, type: :binary_id)

      timestamps()
    end

    create index(:feed_items, [:feed_id])
  end
end
