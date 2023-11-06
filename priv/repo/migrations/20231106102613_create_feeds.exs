defmodule RssFeed.Repo.Migrations.CreateFeeds do
  use Ecto.Migration

  def change do
    create table(:feeds, primary_key: false) do
      add :id, :binary_id, primary_key: true
      add :url, :string
      add :etag, :string
      add :last_modified, :string

      timestamps()
    end

    create unique_index(:feeds, [:url])
  end
end
