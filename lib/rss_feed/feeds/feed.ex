defmodule RssFeed.Feeds.Feed do
  use Ecto.Schema
  import Ecto.Changeset

  @primary_key {:id, :binary_id, autogenerate: true}
  @foreign_key_type :binary_id
  schema "feeds" do
    field :url, :string
    field :etag, :string
    field :last_updated, :utc_datetime

    timestamps()
  end

  @doc false
  def changeset(feed, attrs) do
    feed
    |> cast(attrs, [:url, :etag, :last_updated])
    |> validate_required([:url, :etag, :last_updated])
    |> unique_constraint(:url)
  end
end
