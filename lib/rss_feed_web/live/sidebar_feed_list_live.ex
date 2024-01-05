defmodule RssFeedWeb.SidebarFeedListLive do
  use RssFeedWeb, :live_view
  alias RssFeed.Feeds
  alias RssFeed.Imagehelper

  def render(assigns) do
    ~H"""
    <.nav_links>
      <:item link={~p"/"} title="Top Feeds" icon="hero-fire">
        Top Feeds
      </:item>
      <:item link={~p"/"} title="Bookmarks" icon="hero-bookmark">
        Bookmarks
      </:item>
    </.nav_links>
    <.feed_list>
      <:item
        :for={feed <- @feeds}
        link={~p"/feeds/#{feed.id}"}
        title={feed.title}
        image={Imagehelper.select(nil, feed.image, ~p"/images/empty_image.svg")}
      >
        <%= feed.title %>
      </:item>
    </.feed_list>
    <.link
      href={~p"/feeds/new"}
      class="flex items-center p-2 text-base font-medium text-gray-800  rounded-lg dark:text-gray-400 hover:bg-gray-100 dark:hover:bg-gray-700 group"
    >
      <.icon name="hero-plus" class="h-5 w-5" />
      <span class="ml-3">Add New Feed</span>
    </.link>
    """
  end

  def mount(_params, _session, socket) do
    {:ok, assign(socket, :feeds, Feeds.list_feeds())}
  end
end
