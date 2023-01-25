module RssTests exposing (..)

import Expect exposing (Expectation)
import Rss
import Test exposing (..)
import Time


suite : Test
suite =
    describe "generated xml"
        [ test "relative urls" <|
            \() ->
                Rss.generate
                    { title = "elm-pages Blog"
                    , description = "Learn about elm-pages and get new release notifications."
                    , url = "https://elm-pages.com/blog"
                    , lastBuildTime = Time.millisToPosix 1591330166000
                    , generator = Just "elm-pages"
                    , items =
                        [ { title = "Generating files with elm-pages"
                          , description = "Learn all about the new generateFiles hook."
                          , url = "blog/generate-files"
                          , categories = [ "Elm", "Static Site Generator" ]
                          , author = "Dillon Kearns"
                          , pubDate = Rss.DateTime (Time.millisToPosix 1591330166000)
                          , content = Nothing
                          , contentEncoded = Nothing
                          , enclosure = Nothing
                          }
                        ]
                    , siteUrl = "https://elm-pages.com"
                    }
                    |> Expect.equal
                        """<rss version="2.0" xmlns:atom="http://www.w3.org/2005/Atom" xmlns:content="http://purl.org/rss/1.0/modules/content/" xmlns:dc="http://purl.org/dc/elements/1.1/">
<channel>
<title>elm-pages Blog</title>
<description>Learn about elm-pages and get new release notifications.</description>
<link>https://elm-pages.com/blog</link>
<lastBuildDate>Fri, 05 Jun 2020 04:09:26 +0000</lastBuildDate>
<generator>elm-pages</generator>
<item>
<title>Generating files with elm-pages</title>
<description>Learn all about the new generateFiles hook.</description>
<link>https://elm-pages.com/blog/generate-files</link>
<guid>https://elm-pages.com/blog/generate-files</guid>
<pubDate>Fri, 05 Jun 2020 04:09:26 +0000</pubDate>
<category>Elm</category>
<category>Static Site Generator</category>
</item>
</channel>
</rss>"""
        , test "encoded content" <|
            \() ->
                Rss.generate
                    { title = "elm-pages Blog"
                    , description = "Learn about elm-pages and get new release notifications."
                    , url = "https://elm-pages.com/blog"
                    , lastBuildTime = Time.millisToPosix 1591330166000
                    , generator = Just "elm-pages"
                    , items =
                        [ { title = "Generating files with elm-pages"
                          , description = "Learn all about the new generateFiles hook."
                          , url = "blog/generate-files"
                          , categories = []
                          , author = "Dillon Kearns"
                          , pubDate = Rss.DateTime (Time.millisToPosix 1591330166000)
                          , content = Nothing
                          , contentEncoded = Just "<h1>Hello!</h1><p>Some feed readers will render this as HTML</p>"
                          , enclosure =
                                Just
                                    { url = "https://example.com/image.jpg"
                                    , mimeType = "image/jpeg"
                                    , bytes = Nothing
                                    }
                          }
                        ]
                    , siteUrl = "https://elm-pages.com"
                    }
                    |> equalMultiline
                        """<rss version="2.0" xmlns:atom="http://www.w3.org/2005/Atom" xmlns:content="http://purl.org/rss/1.0/modules/content/" xmlns:dc="http://purl.org/dc/elements/1.1/">
<channel>
<title>elm-pages Blog</title>
<description>Learn about elm-pages and get new release notifications.</description>
<link>https://elm-pages.com/blog</link>
<lastBuildDate>Fri, 05 Jun 2020 04:09:26 +0000</lastBuildDate>
<generator>elm-pages</generator>
<item>
<title>Generating files with elm-pages</title>
<description>Learn all about the new generateFiles hook.</description>
<link>https://elm-pages.com/blog/generate-files</link>
<guid>https://elm-pages.com/blog/generate-files</guid>
<pubDate>Fri, 05 Jun 2020 04:09:26 +0000</pubDate>
<content:encoded>&lt;h1&gt;Hello!&lt;/h1&gt;&lt;p&gt;Some feed readers will render this as HTML&lt;/p&gt;</content:encoded>
<enclosure length="0" type="image/jpeg" url="https://example.com/image.jpg"></enclosure>
</item>
</channel>
</rss>"""
        ]


equalMultiline : String -> String -> Expectation
equalMultiline a b =
    String.lines b
        |> Expect.equalLists (String.lines a)
