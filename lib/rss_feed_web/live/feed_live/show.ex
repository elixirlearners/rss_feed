defmodule RssFeedWeb.FeedLive.Show do
  alias RssFeed.FeedItems
  use RssFeedWeb, :live_view
  alias RssFeed.Imagehelper
  alias RssFeed.Datehelper
  alias RssFeed.Feeds

  @impl true
  def mount(_params, _session, socket) do
    {:ok, socket}
  end

  @impl true
  def handle_params(%{"id" => id, "entry_id" => entry_id}, _, socket) do
    entry = FeedItems.get_feed_item!(entry_id)
    feed = Feeds.get_feed!(id)

    {:noreply,
     socket
     |> assign(
       :page_title,
       page_title(socket.assigns.live_action, feed.title <> " - " <> entry.title)
     )
     |> assign(:feed, feed)
     |> assign(:entry, entry)}
  end

  @impl true
  def handle_params(%{"id" => id}, _, socket) do
    feed = Feeds.get_feed!(id)

    {:noreply,
     socket
     |> assign(:page_title, page_title(socket.assigns.live_action, feed))
     |> assign(:feed, feed)}
  end

  defp page_title(:index, %{title: title}), do: title
  defp page_title(:entry, title), do: title
end
