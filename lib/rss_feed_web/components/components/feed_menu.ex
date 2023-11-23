defmodule RssFeedWeb.Components.SideMenu do
  use Phoenix.Component
  import RssFeedWeb.CoreComponents

  slot :item, required: true do
    attr :link, :any, required: true
    attr :title, :string, required: true
    attr :image, :string, required: true
  end

  def feed_list(assigns) do
    ~H"""
    <h3 class="p-3 mt-3 text-sm font-bold text-gray-500 dark:text-gray-500 group flex">
      My Subscriptions <.icon name="hero-rss-mini" class="ml-auto mt-1 w-4 h-4" />
    </h3>
    <ul class="pt-2 space-y-1 border-t border-gray-200 dark:border-gray-700">
      <li :for={item <- @item}>
        <.link
          title={item.title}
          navigate={item.link}
          class="flex items-center p-2 text-sm font-medium text-gray-900 rounded-lg transition duration-75 hover:bg-gray-100 dark:hover:bg-gray-700 dark:text-white group"
        >
          <img src={item.image} class="w-9 h-9 mr-2 rounded" />
          <span class="ml-1 truncate"><%= render_slot(item) %></span>
        </.link>
      </li>
    </ul>
    """
  end

  slot :item, required: true do
    attr :link, :any, required: true
    attr :icon, :string, required: true
    attr :title, :string, required: true
  end

  def nav_links(assigns) do
    ~H"""
    <ul class="space-y-2">
      <li :for={item <- @item}>
        <a
          href={item.link}
          class="flex items-center p-2 text-base font-medium text-gray-900 rounded-lg dark:text-white hover:bg-gray-100 dark:hover:bg-gray-700 group"
        >
          <.icon name={item.icon} class="h-5 w-5" />
          <span class="ml-3"><%= render_slot(item) %></span>
        </a>
      </li>
    </ul>
    """
  end
end
