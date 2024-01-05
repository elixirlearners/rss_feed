defmodule RssFeed.FeedFetcher.ScheduledUpdate do
  @scheduler Application.compile_env(:rss_feed, :scheduler)

  use GenServer
  require Logger
  alias RssFeed.FeedItems
  alias RssFeed.Feeds

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

  # 60 minutes
  @interval 60 * 60 * 1000

  def start_link(_opts) do
    GenServer.start_link(__MODULE__, %{})
  end

  @impl true
  def init(state) do
    Logger.info("Starting rss feed scheduler")

    @scheduler.run_scheduled_task()

    @scheduler.schedule_next_update()

    {:ok, state}
  end

  @impl true
  def handle_info(:update, state) do
    @scheduler.run_scheduled_task()

    @scheduler.schedule_next_update()

    {:noreply, state}
  end

  def handle_info({:ok, feed, nil}, state) do
    Logger.info("Received no new data for #{feed.url}")

    {:noreply, state}
  end

  def handle_info({:ok, feed, data}, state) do
    Logger.info("New data for #{feed.url}")

    # TODO: Turn the loop into a transaction. Currently making N insertions
    with {:ok, feed_struct} <- Feeds.update_feed(feed, data),
         feed_entries <- FeedItems.build_feed_item_associations(feed_struct, data.entries) do
      Enum.each(feed_entries, fn entry -> FeedItems.upsert_feed_item(entry) end)
    else
      {:error, msg} -> Logger.error(msg)
    end

    {:noreply, state}
  end

  def handle_info({:error, %{location: url, feed: feed}}, state) do
    Logger.alert("Received new location: #{url}}")

    {:ok, updated_feed} = Feeds.update_feed(feed, %{url: url})
    IO.inspect(updated_feed)

    parent_pid = self()

    spawn(RssFeed.FeedFetcher.Worker, :run, [updated_feed, parent_pid])

    {:noreply, state}
  end

  def handle_info({:error, url}, state) do
    Logger.alert("Received error for #{url}")

    {:noreply, state}
  end

  def schedule_next_update do
    Process.send_after(self(), :update, @interval)
  end

  def run_scheduled_task do
    Logger.info("Starting work update")

    parent_pid = self()

    Feeds.list_all_due_for_update()
    |> Enum.each(fn feed ->
      spawn(RssFeed.FeedFetcher.Worker, :run, [feed, parent_pid])
    end)
  end
end
