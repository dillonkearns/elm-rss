module Rss exposing (generate, Item, DateOrTime(..), Enclosure)

{-| Build a feed following the RSS 2.0 format <https://validator.w3.org/feed/docs/rss2.html>.
<http://www.rssboard.org/rss-specification>

@docs generate, Item, DateOrTime, Enclosure

-}

import Date
import Dict
import Imf.DateTime
import Path
import Time
import Xml
import Xml.Encode exposing (..)


{-| Can be one of:

  - `Rss.Date` - a `Date` value from `justinmimbs/date`, or
  - `Rss.DateTime` - a `Time.Posix` from `elm/time`.

If you pass in an `Rss.Date`, it will format it at `00:00:00 GMT` on the given date (start of day).
If you pass in an `Rss.DateTime`, it will format the time in UTC.

-}
type DateOrTime
    = Date Date.Date
    | DateTime Time.Posix


{-| Data representing an RSS feed item.

contentEncoded - Use this to
[add HTML content](https://developer.mozilla.org/en-US/docs/Archive/RSS/Article/Why_RSS_Content_Module_is_Popular_-_Including_HTML_Contents)
in a `<content:encoded>` tag in the RSS feed. Some feed readers
will use this field if present to render HTML. Note that Elm doesn't
provide a way to turn `Html.Html` values into a `String`.

You can use [`zwilias/elm-html-string`](https://package.elm-lang.org/packages/zwilias/elm-html-string/latest/) to
render HTML using a drop-in replacement API and then turn that into a String.

Here's an example that shows how to [render to an HTML String
using `dillonkearns/elm-markdown`](https://github.com/dillonkearns/elm-markdown/blob/2650722990d61c8948d7998168d3bceb0ee6f298/spec-tests/OutputMarkdownHtml.elm).

<https://demo.ghost.io/author/lewis/rss/>

Encoding

enclosure - link to an attached file

<https://www.rssboard.org/rss-enclosures-use-case>

-}
type alias Item =
    { title : String
    , description : String
    , url : String
    , categories : List String
    , author : String
    , pubDate : DateOrTime
    , content : Maybe String
    , contentEncoded : Maybe String
    , enclosure :
        Maybe
            { url : String
            , mimeType : String
            , bytes : Maybe Int
            }

    {-
       TODO consider adding these
          - lat optional number The latitude coordinate of the item.
          - long optional number The longitude coordinate of the item.
          - custom_elements optional array Put additional elements in the item (node-xml syntax)
    -}
    }


{-| Represents a linked file.

<https://validator.w3.org/feed/docs/rss2.html#ltenclosuregtSubelementOfLtitemgt>

-}
type alias Enclosure =
    { url : String
    , mimeType : String
    , bytes : Maybe Int
    }


{-| Generate an RSS feed from feed metadata and a list of `Rss.Item`s.
-}
generate :
    { title : String
    , description : String
    , url : String
    , lastBuildTime : Time.Posix
    , generator : Maybe String
    , items : List Item
    , siteUrl : String
    }
    -> String
generate feed =
    object
        [ ( "rss"
          , Dict.fromList
                [ ( "xmlns:dc", string "http://purl.org/dc/elements/1.1/" )
                , ( "xmlns:content", string "http://purl.org/rss/1.0/modules/content/" )
                , ( "xmlns:atom", string "http://www.w3.org/2005/Atom" )
                , ( "version", string "2.0" )
                ]
          , object
                [ ( "channel"
                  , Dict.empty
                  , [ [ keyValue "title" feed.title
                      , keyValue "description" feed.description
                      , keyValue "link" feed.url

                      --<atom:link href="http://dallas.example.com/rss.xml" rel="self" type="application/rss+xml" />
                      , keyValue "lastBuildDate" <| Imf.DateTime.fromPosix Time.utc feed.lastBuildTime
                      ]
                    , [ feed.generator |> Maybe.map (keyValue "generator") ] |> List.filterMap identity
                    , List.map (itemXml feed.siteUrl) feed.items
                    ]
                        |> List.concat
                        |> list
                  )
                ]
          )
        ]
        |> Xml.Encode.encode 0


itemXml : String -> Item -> Xml.Value
itemXml siteUrl item =
    object
        [ ( "item"
          , Dict.empty
          , list
                ([ keyValue "title" item.title
                 , keyValue "description" item.description
                 , keyValue "link" (Path.join [ siteUrl, item.url ])
                 , keyValue "guid" (Path.join [ siteUrl, item.url ])
                 , keyValue "pubDate" (formatDateOrTime item.pubDate)
                 ]
                    ++ ([ item.content |> Maybe.map (\content -> keyValue "content" content)
                        , item.contentEncoded |> Maybe.map (\content -> keyValue "content:encoded" (wrapInCdata content))
                        , item.enclosure |> Maybe.map encodeEnclosure

                        --<enclosure url="https://example.com/image.jpg" length="0" type="image/jpeg"/>
                        ]
                            |> List.filterMap identity
                       )
                )
          )
        ]


encodeEnclosure : Enclosure -> Xml.Value
encodeEnclosure enclosure =
    Xml.Encode.object
        [ ( "enclosure"
          , Dict.fromList
                [ ( "url", string enclosure.url )
                , ( "length", string "0" )
                , ( "type", string enclosure.mimeType )
                ]
          , Xml.Encode.null
          )
        ]


wrapInCdata content =
    "<![CDATA[" ++ content ++ "]]>"


formatDateOrTime : DateOrTime -> String
formatDateOrTime dateOrTime =
    case dateOrTime of
        Date date ->
            formatDate date

        DateTime posix ->
            Imf.DateTime.fromPosix Time.utc posix


formatDate : Date.Date -> String
formatDate date =
    Date.format "EEE, dd MMM yyyy" date
        ++ " 00:00:00 GMT"


keyValue : String -> String -> Xml.Value
keyValue key value =
    object [ ( key, Dict.empty, string value ) ]
