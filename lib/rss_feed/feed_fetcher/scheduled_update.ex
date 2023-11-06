defmodule RssFeed.FeedFetcher.ScheduledUpdate do
  use GenServer

  @moduledoc """
  Polling RSS Feed updates policy

  1. Make use of HTTP cache. Send Etag and LastModified headers. Recognize 304 Not modified response.
      This way you can save a lot of bandwidth. Additionally some scripts recognize the LastModified header and
      return only partial contents (ie. only the two or three newest items instead of all 30 or so).
  2. Don’t poll RSS from services that supports RPC Ping (or other PUSH service, such as PubSubHubbub).
      I.e. if you’re receiving PUSH notifications from a service, you don’t have to poll the data in the standard interval
      — do it once a day to check if the mechanism still works or not (ping can be disabled, reconfigured, damaged, etc).
      This way you can fetch RSS only on receiving notification, not every hour or so.
  3. Check the TTL (in RSS) or cache control headers (Expires in ATOM), and don’t fetch until resource expires.
  4. Try to adapt to frequency of new items in each single RSS feed. If in the past week there were only two updates in particular feed,
      don’t fetch it more than once a day. AFAIR Google Reader does that.
  5. Lower the rate at night hours or other time when the traffic on your site is low.
  6. At last, do it once a hour
  """

  # twenty minutes
  @interval 20 * 60 * 1000

  def start_link(_opts) do
    GenServer.start_link(__MODULE__, %{})
  end

  @impl true
  def init(state) do
    IO.puts("Starting rss feed scheduler")

    schedule_next_update()

    {:ok, state}
  end

  @impl true
  def handle_info(:update, state) do
    run_scheduled_task()

    schedule_next_update()

    {:noreply, state}
  end

  def handle_info({:ok, message}, state) do
    IO.inspect(message, label: "Received message")

    {:noreply, state}
  end

  def handle_info({:error, url}, state) do
    IO.inspect("Received error for #{url}")

    {:noreply, state}
  end

  defp schedule_next_update do
    Process.send_after(self(), :update, @interval)
  end

  defp run_scheduled_task do
    IO.puts("Starting work update")

    parent_pid = self()

    feeds = [
      %{url: "https://rss.art19.com/smartless"},
      %{url: "https://feeds.megaphone.fm/newheights"},
      %{url: "https://podcastfeeds.nbcnews.com/RPWEjhKq"},
      %{url: "https://rss.art19.com/-exposed-"}
    ]

    Enum.each(feeds, fn feed ->
      spawn(RssFeed.FeedFetcher.Worker, :run, [feed.url, parent_pid])
    end)
  end
end
