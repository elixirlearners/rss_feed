defmodule RssFeed.Imagehelper do
  def select(primary, _, _) when primary != nil do
    primary
  end

  def select(nil, secondary, _) when secondary != nil do
    secondary
  end

  def select(nil, nil, fallback) do
    fallback
  end
end
