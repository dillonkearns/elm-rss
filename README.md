# `elm-rss`

A simple interface for building a String of an RSS feed from structured elm data.

Follows the [the RSS 2.0 specification](http://www.rssboard.org/rss-specification).

Made for use with [`elm-pages`](https://github.com/dillonkearns/elm-pages).

*Note*: this package was built as utility for `elm-pages` apps,
and it may be become more coupled to `elm-pages` over time.

## Example
Here's an example from an `elm-pages` app.

```elm
module Feed exposing (fileToGenerate)

import Metadata exposing (Metadata(..))
import Pages
import Pages.PagePath as PagePath exposing (PagePath)
import Rss


generate :
    { siteTagline : String
    , siteUrl : String
    }
    ->
        List
            { path : PagePath Pages.PathKey
            , frontmatter : Metadata
            , body : String
            }
    -> String
generate { siteTagline, siteUrl } siteMetadata =
    Rss.generate
        { title = "elm-pages Blog"
        , description = siteTagline
        , url = "https://elm-pages.com/blog"
        , lastBuildTime = Pages.builtAt
        , generator = Just "elm-pages"
        , items = siteMetadata |> List.filterMap metadataToRssItem
        , siteUrl = siteUrl
        }


metadataToRssItem :
    { path : PagePath Pages.PathKey
    , frontmatter : Metadata
    , body : String
    }
    -> Maybe Rss.Item
metadataToRssItem page =
    case page.frontmatter of
        Article article ->
            Just
                { title = article.title
                , description = article.description
                , url = PagePath.toString page.path
                , categories = []
                , author = article.author.name
                , pubDate = Rss.Date article.published
                , content = Nothing
                }

        _ ->
            Nothing

```
