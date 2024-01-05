defmodule RssFeedWeb.Components.Layout do
  use Phoenix.Component

  slot :left, required: true
  slot :right, required: true

  def app_header(assigns) do
    ~H"""
    <nav class="bg-gray-100 border-b border-gray-200 px-4 py-2.5 dark:bg-gray-800 dark:border-gray-700 fixed left-0 right-0 top-0 z-50">
      <div class="flex flex-wrap justify-between items-center">
        <div class="flex justify-start items-center">
          <%= render_slot(@left) %>
        </div>
        <div class="flex items-center lg:order-2">
          <%= render_slot(@right) %>
        </div>
      </div>
    </nav>
    """
  end

  slot :inner_block, required: true

  def main_content(assigns) do
    ~H"""
    <main class="md:ml-72 h-auto">
      <%= render_slot(@inner_block) %>
    </main>
    """
  end

  slot :inner_block, required: true
  attr :id, :string, default: "drawer-navigation"

  def sidebar_drawer(assigns) do
    ~H"""
    <aside
      class="fixed top-0 left-0 z-40 w-72 h-screen pt-14 transition-transform -translate-x-full bg-white border-r border-gray-200 lg:translate-x-0 dark:bg-gray-800 dark:border-gray-700"
      aria-label="Sidenav"
      id={@id}
    >
      <div class="overflow-y-auto py-5 px-3 h-full bg-gray-100 dark:bg-gray-800">
        <%= render_slot(@inner_block) %>
      </div>
    </aside>
    """
  end

  attr :target_id, :string, default: "drawer-navigation"

  def sidebar_trigger(assigns) do
    ~H"""
    <button
      data-drawer-target={@target_id}
      data-drawer-toggle={@target_id}
      aria-controls={@target_id}
      class="p-2 mr-2 text-gray-600 rounded-lg cursor-pointer lg:hidden hover:text-gray-900 hover:bg-gray-100 focus:bg-gray-100 dark:focus:bg-gray-700 focus:ring-2 focus:ring-gray-100 dark:focus:ring-gray-700 dark:text-gray-400 dark:hover:bg-gray-700 dark:hover:text-white"
    >
      <svg
        aria-hidden="true"
        class="w-6 h-6"
        fill="currentColor"
        viewBox="0 0 20 20"
        xmlns="http://www.w3.org/2000/svg"
      >
        <path
          fill-rule="evenodd"
          d="M3 5a1 1 0 011-1h12a1 1 0 110 2H4a1 1 0 01-1-1zM3 10a1 1 0 011-1h6a1 1 0 110 2H4a1 1 0 01-1-1zM3 15a1 1 0 011-1h12a1 1 0 110 2H4a1 1 0 01-1-1z"
          clip-rule="evenodd"
        >
        </path>
      </svg>
      <svg
        aria-hidden="true"
        class="hidden w-6 h-6"
        fill="currentColor"
        viewBox="0 0 20 20"
        xmlns="http://www.w3.org/2000/svg"
      >
        <path
          fill-rule="evenodd"
          d="M4.293 4.293a1 1 0 011.414 0L10 8.586l4.293-4.293a1 1 0 111.414 1.414L11.414 10l4.293 4.293a1 1 0 01-1.414 1.414L10 11.414l-4.293 4.293a1 1 0 01-1.414-1.414L8.586 10 4.293 5.707a1 1 0 010-1.414z"
          clip-rule="evenodd"
        >
        </path>
      </svg>
      <span class="sr-only">Toggle sidebar</span>
    </button>
    """
  end

  slot :inner_block, required: true
  attr :id, :string, default: "feed_sidebar"

  def feed_sidebar(assigns) do
    ~H"""
    <aside
      class="fixed top z-38 w-72 xl:w-96 h-screen pt-16 transition-transform -translate-x-full lg:translate-x-0 bg-gray-50 border-r border-gray-200 dark:bg-gray-900 dark:border-gray-800"
      aria-label="Feedlist"
      id={@id}
    >
      <div class="overflow-y-auto p-3 h-full">
        <%= render_slot(@inner_block) %>
      </div>
    </aside>
    """
  end
end
