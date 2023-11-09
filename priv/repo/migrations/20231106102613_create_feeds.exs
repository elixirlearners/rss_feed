defmodule RssFeed.Repo.Migrations.CreateFeeds do
  use Ecto.Migration

  def change do
    create table(:feeds, primary_key: false) do
      add :id, :binary_id, primary_key: true
      add :url, :text
      add :etag, :string
      add :last_modified, :string
      # Feederex fields
      add :author, :text
      add :image, :text
      add :link, :text
      add :language, :string
      add :subtitle, :text
      add :summary, :text
      add :title, :text
      add :updated, :string

      timestamps()
    end

    create unique_index(:feeds, [:url])
  end
end
