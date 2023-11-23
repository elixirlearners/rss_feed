defmodule RssFeed.Datehelper do
  def parse(datestr) do
    case DateTime.from_iso8601(datestr) do
      {:ok, date, _} -> to_human(date)
      _ -> datestr
    end
  end

  def to_human(calendar_date) do
    Calendar.strftime(calendar_date, "%b. %d, %Y")
  end
end
