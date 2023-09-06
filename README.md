# `elm-rss`

A simple interface for building a String of an RSS feed from structured elm data.

Follows the [the RSS 2.0 specification](http://www.rssboard.org/rss-specification).

Made for use with [`elm-pages`](https://github.com/dillonkearns/elm-pages).

*Note*: this package was built as utility for `elm-pages` apps,
and it may be become more coupled to `elm-pages` over time.

## Example
Here's an example from an `elm-pages` app.

```elm
module Api exposing (routes)

import ApiRoute
import Article
import BackendTask exposing (BackendTask)
import FatalError exposing (FatalError)
import Head
import Html exposing (Html)
import Pages
import Route exposing (Route)
import Rss
import SiteOld
import Time


routes :
    BackendTask FatalError (List Route)
    -> (Maybe { indent : Int, newLines : Bool } -> Html Never -> String)
    -> List (ApiRoute.ApiRoute ApiRoute.Response)
routes getStaticRoutes htmlToString =
    [ rss
        { siteTagline = SiteOld.tagline
        , siteUrl = SiteOld.canonicalUrl
        , title = "elm-pages Blog"
        , builtAt = Pages.builtAt
        , indexPage = [ "blog" ]
        }
        postsBackendTask
    ]


postsBackendTask : BackendTask FatalError (List Rss.Item)
postsBackendTask =
    Article.allMetadata
        |> BackendTask.map
            (List.map
                (\( route, article ) ->
                    { title = article.title
                    , description = article.description
                    , url =
                        route
                            |> Route.routeToPath
                            |> String.join "/"
                    , categories = []
                    , author = "Dillon Kearns"
                    , pubDate = Rss.Date article.published
                    , content = Nothing
                    , contentEncoded = Nothing
                    , enclosure = Nothing
                    }
                )
            )
        |> BackendTask.allowFatal


rss :
    { siteTagline : String
    , siteUrl : String
    , title : String
    , builtAt : Time.Posix
    , indexPage : List String
    }
    -> BackendTask FatalError (List Rss.Item)
    -> ApiRoute.ApiRoute ApiRoute.Response
rss options itemsRequest =
    ApiRoute.succeed
        (itemsRequest
            |> BackendTask.map
                (\items ->
                    Rss.generate
                        { title = options.title
                        , description = options.siteTagline
                        , url = options.siteUrl ++ "/" ++ String.join "/" options.indexPage
                        , lastBuildTime = options.builtAt
                        , generator = Just "elm-pages"
                        , items = items
                        , siteUrl = options.siteUrl
                        }
                )
        )
        |> ApiRoute.literal "blog/feed.xml"
        |> ApiRoute.single
        |> ApiRoute.withGlobalHeadTags
            (BackendTask.succeed
                [ Head.rssLink "/blog/feed.xml"
                ]
            )
```
