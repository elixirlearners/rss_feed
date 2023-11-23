defmodule RssFeed.Feeds.Feed do
  alias RssFeed.SanitizeHTML
  use Ecto.Schema
  import Ecto.Changeset

  @primary_key {:id, :binary_id, autogenerate: true}
  @foreign_key_type :binary_id
  schema "feeds" do
    field :url, :string
    # Metadata
    field :etag, :string
    field :last_modified, :string
    # Feederex fields
    field :author, :string
    field :image, :string
    field :link, :string
    field :language, :string
    field :subtitle, :string
    field :summary, :string
    field :title, :string
    field :updated, :string
    # Association
    has_many :entries, RssFeed.FeedItems.FeedItem, on_replace: :delete_if_exists
    timestamps()
  end

  @doc false
  def changeset(feed, attrs) do
    feed
    |> cast(attrs, [:url])
    |> validate_required([:url])
    |> unique_constraint(:url)
  end

  def changeset_update_data(feed, attrs) do
    attrs = SanitizeHTML.sanitize_attrs(attrs)

    feed
    |> cast(attrs, [
      :etag,
      :last_modified,
      :author,
      :image,
      :link,
      :language,
      :subtitle,
      :summary,
      :title,
      :updated
    ])
    |> cast_assoc(:entries, required: false, with: &RssFeed.FeedItems.FeedItem.changeset/2)
  end
end
