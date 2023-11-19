defmodule RssFeedWeb.SidebarFeedListLive do
  use RssFeedWeb, :live_view
  alias RssFeed.Feeds

  def render(assigns) do
    IO.inspect(assigns)

    ~H"""
    <h3 class="p-2 mt-3 text-xs font-bold text-gray-500 dark:text-gray-500 group">
      My Subscriptions
    </h3>
    <ul class="pt-1 space-y-1">
      <%= for {_id, feed} <- @streams.feeds do %>
        <li>
          <.link
            navigate={~p"/feeds/#{feed.id}"}
            class="flex items-center p-1 text-sm font-medium text-gray-900 rounded-lg transition duration-75 hover:bg-gray-100 dark:hover:bg-gray-700 dark:text-white group"
          >
            <span class="ml-1 truncate"><%= feed.title %></span>
          </.link>
        </li>
      <% end %>
    </ul>
    """
  end

  def mount(_params, _session, socket) do
    {:ok, stream(socket, :feeds, Feeds.list_feeds())}
  end
end
