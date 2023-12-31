defmodule RssFeed.FeedFetcher.WorkerTest do
  use ExUnit.Case
  use RssFeedWeb.ConnCase
  alias RssFeed.FeedFetcher.Worker
  import RssFeed.FeedsFixtures

  defmodule MockHTTPoison do
    @rss_response """
    <?xml version="1.0"?>
    <rss version="2.0">
    <channel>
    <title>Liftoff News</title>
    <link>http://liftoff.msfc.nasa.gov/</link>
    <atom:link>http://liftoff.msfc.nasa.gov/feed/</atom:link>
    <description>Liftoff to Space Exploration.</description>
    <language>en-us</language>
    <pubDate>Tue, 10 Jun 2003 04:00:00 GMT</pubDate>
    <lastBuildDate>Tue, 10 Jun 2003 09:41:01 GMT</lastBuildDate>
    <docs>http://blogs.law.harvard.edu/tech/rss</docs>
    <generator>Weblog Editor 2.0</generator>
    <managingEditor>editor@example.com</managingEditor>
    <webMaster>webmaster@example.com</webMaster>
    <item>
       <title>Star City</title>
       <category><![CDATA[News]]></category>
       <category><![CDATA[Current Events]]></category>
       <link>http://liftoff.msfc.nasa.gov/news/2003/news-starcity.asp</link>
       <description>How do Americans get ready to work with Russians aboard the International Space Station? They take a crash course in culture, language and protocol at Russia's &lt;a href="http://howe.iki.rssi.ru/GCTC/gctc_e.htm"&gt;Star City&lt;/a&gt;.</description>
       <pubDate>Tue, 03 Jun 2003 09:39:21 GMT</pubDate>
       <guid>http://liftoff.msfc.nasa.gov/2003/06/03.html#item573</guid>
    </item>
    <item>
       <category><![CDATA[News]]></category>
       <description>Sky watchers in Europe, Asia, and parts of Alaska and Canada will experience a &lt;a href="http://science.nasa.gov/headlines/y2003/30may_solareclipse.htm"&gt;partial eclipse of the Sun&lt;/a&gt; on Saturday, May 31st.</description>
       <pubDate>Fri, 30 May 2003 11:06:42 GMT</pubDate>
       <guid>http://liftoff.msfc.nasa.gov/2003/05/30.html#item572</guid>
    </item>
    <item>
       <title>The Engine That Does More</title>
       <link>http://liftoff.msfc.nasa.gov/news/2003/news-VASIMR.asp</link>
       <description>Before man travels to Mars, NASA hopes to design new engines that will let us fly through the Solar System more quickly.  The proposed VASIMR engine would do that.</description>
       <pubDate>Tue, 27 May 2003 08:37:32 GMT</pubDate>
       <guid>http://liftoff.msfc.nasa.gov/2003/05/27.html#item571</guid>
    </item>
    <item>
       <title>Astronauts' Dirty Laundry</title>
       <category><![CDATA[News]]></category>
       <link>http://liftoff.msfc.nasa.gov/news/2003/news-laundry.asp</link>
       <description>Compared to earlier spacecraft, the International Space Station has many luxuries, but laundry facilities are not one of them.  Instead, astronauts have other options.</description>
       <pubDate>Tue, 20 May 2003 08:56:02 GMT</pubDate>
       <guid>http://liftoff.msfc.nasa.gov/2003/05/20.html#item570</guid>
    </item>
    </channel>
    </rss>
    """

    def get("http://example.com", _headers) do
      {:ok, %HTTPoison.Response{body: @rss_response, status_code: 200}}
    end

    def get("http://example.com/with_headers", _headers) do
      headers = [
        "Content-Type": "application/xml",
        ETag: "W123",
        "Last-Modified": "Tue, 10 Jun 2003 04:00:00 GMT"
      ]

      {:ok, %HTTPoison.Response{body: @rss_response, status_code: 304, headers: headers}}
    end

    def get("http://malformed.com", _) do
      rss_response = """
      <?xml version="1.0"?>
      <xml malformed />
      """

      {:ok, %HTTPoison.Response{body: rss_response, status_code: 200}}
    end

    def get("http://404.com", _) do
      {:ok, %HTTPoison.Response{body: "Not found", status_code: 404}}
    end

    def get("http://error.com", _) do
      {:error, %HTTPoison.Error{reason: "some error"}}
    end
  end

  setup do
    [parent_pid: self()]
  end

  test "Receives an xml response", context do
    feed = feed_fixture()

    Worker.run(%{feed | url: "http://example.com"}, context[:parent_pid], MockHTTPoison)

    assert_received {:ok, _,
                     %{
                       title: "Liftoff News",
                       summary: "Liftoff to Space Exploration.",
                       link: "http://liftoff.msfc.nasa.gov/"
                     }}
  end

  test "Receives etag and last-modified headers", context do
    feed = feed_fixture()

    Worker.run(
      %{feed | url: "http://example.com/with_headers"},
      context[:parent_pid],
      MockHTTPoison
    )

    assert_received {:ok, _, nil}
  end

  test "malformed response results in :error", context do
    feed = feed_fixture()

    Worker.run(%{feed | url: "http://malformed.com"}, context[:parent_pid], MockHTTPoison)
    assert_received {:error, "http://malformed.com"}
  end

  @tag capture_log: true
  test "404 results in :error", context do
    feed = feed_fixture()

    Worker.run(%{feed | url: "http://404.com"}, context[:parent_pid], MockHTTPoison)
    assert_received {:error, "http://404.com"}
  end

  @tag capture_log: true
  test "Error results in :error", context do
    feed = feed_fixture()
    Worker.run(%{feed | url: "http://error.com"}, context[:parent_pid], MockHTTPoison)
    assert_received {:error, "http://error.com"}
  end
end
