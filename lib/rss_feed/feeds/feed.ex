defmodule RssFeed.Feeds.Feed do
  use Ecto.Schema
  import Ecto.Changeset

  @primary_key {:id, :binary_id, autogenerate: true}
  @foreign_key_type :binary_id
  schema "feeds" do
    field :url, :string
    field :etag, :string
    field :last_modified, :string

    timestamps()
  end

  @doc false
  def changeset(feed, attrs) do
    feed
    |> cast(attrs, [:url])
    |> validate_required([:url])
    |> unique_constraint(:url)
  end

  def changeset_update_metadata(feed, attrs) do
    feed
    |> cast(attrs, [:etag, :last_modified])
  end
end
