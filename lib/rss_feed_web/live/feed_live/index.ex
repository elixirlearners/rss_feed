defmodule RssFeedWeb.FeedLive.Index do
  use RssFeedWeb, :live_view

  alias RssFeed.Feeds
  alias RssFeed.Feeds.Feed

  @impl true
  def mount(_params, _session, socket) do
    {:ok, stream(socket, :feeds, Feeds.list_feeds())}
  end

  @impl true
  def handle_params(params, _url, socket) do
    {:noreply, apply_action(socket, socket.assigns.live_action, params)}
  end

  defp apply_action(socket, :edit, %{"id" => id}) do
    socket
    |> assign(:page_title, "Edit Feed")
    |> assign(:feed, Feeds.get_feed!(id))
  end

  defp apply_action(socket, :new, _params) do
    socket
    |> assign(:page_title, "New Feed")
    |> assign(:feed, %Feed{})
  end

  defp apply_action(socket, :index, _params) do
    socket
    |> assign(:page_title, "Listing Feeds")
    |> assign(:feed, nil)
  end

  @impl true
  def handle_info({RssFeedWeb.FeedLive.FormComponent, {:saved, feed}}, socket) do
    {:noreply, stream_insert(socket, :feeds, feed)}
  end

  @impl true
  def handle_event("delete", %{"id" => id}, socket) do
    feed = Feeds.get_feed!(id)
    {:ok, _} = Feeds.delete_feed(feed)

    {:noreply, stream_delete(socket, :feeds, feed)}
  end
end
