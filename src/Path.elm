module Path exposing (join)


join : List String -> String
join urls =
    urls
        |> List.map dropBoth
        |> String.join "/"


dropBoth : String -> String
dropBoth url =
    url |> dropLeading |> dropTrailing


dropLeading : String -> String
dropLeading url =
    if String.startsWith "/" url then
        String.dropLeft 1 url

    else
        url


dropTrailing : String -> String
dropTrailing url =
    if String.endsWith "/" url then
        String.dropRight 1 url

    else
        url
