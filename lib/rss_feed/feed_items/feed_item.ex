defmodule RssFeed.FeedItems.FeedItem do
  alias RssFeed.SanitizeHTML
  use Ecto.Schema
  import Ecto.Changeset

  @primary_key {:id, :binary_id, autogenerate: true}
  @foreign_key_type :binary_id
  schema "feed_items" do
    field :link, :string
    field :title, :string
    field :author, :string
    field :image, :string
    field :categories, {:array, :string}
    field :duration, :string
    field :enclosure, :string
    field :subtitle, :string
    field :summary, :string
    field :updated, :string
    field :source_id, :string
    # :on_replace - The action taken on associations when the record is replaced
    belongs_to :feed, RssFeed.Feeds.Feed, type: :binary_id, on_replace: :update

    timestamps()
  end

  @doc false
  def changeset(feed_item, attrs) do
    attrs = SanitizeHTML.sanitize_attrs(attrs)

    feed_item
    |> cast(attrs, [
      :source_id,
      :author,
      # :categories, # Probably an array
      # :duration,
      # :enclosure,
      :image,
      :link,
      :subtitle,
      :summary,
      :title,
      :updated
    ])
    # |> validate_required([
    #   :source_id,
    #   :title
    # ])
    |> unique_constraint(:source_id)
  end
end
