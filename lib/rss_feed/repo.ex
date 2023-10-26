defmodule RssFeed.Repo do
  use Ecto.Repo,
    otp_app: :rss_feed,
    adapter: Ecto.Adapters.Postgres
end
