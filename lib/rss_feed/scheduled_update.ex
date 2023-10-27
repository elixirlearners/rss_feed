defmodule RssFeed.ScheduledUpdate do
  use GenServer
  # one hour
  @interval 1 * 60 * 60 * 1000

  def start_link(_opts) do
    GenServer.start_link(__MODULE__, %{})
  end

  @impl true
  def init(state) do
    IO.puts("Starting scheduled update")
    schedule_update()

    {:ok, state}
  end

  @impl true
  def handle_info(:update, state) do
    run_scheduled_task()

    schedule_update()

    {:noreply, state}
  end

  defp schedule_update do
    Process.send_after(self(), :update, @interval)
  end

  defp run_scheduled_task do
    IO.puts("Starting work update")
    RssFeed.Fetcher.run("https://rss.art19.com/smartless")
  end
end
