defmodule RssFeed.SanitizeHTML do
  def sanitize_attrs(%{"summary" => _} = attrs) do
    attrs
    |> Map.update!("summary", fn summary -> HtmlSanitizeEx.basic_html(summary) end)
  end

  def sanitize_attrs(attrs), do: attrs
end
