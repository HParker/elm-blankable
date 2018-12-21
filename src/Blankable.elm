module Blankable exposing (..)

import Html exposing (Html)
import RemoteData exposing (WebData)


blanker : (List (Html.Attribute msg) -> List (Html msg) -> Html msg) -> List (Html.Attribute msg) -> (WebData a -> List (Html msg)) -> WebData a -> Html msg
blanker tag attributes accessor data =
    case data of
        RemoteData.Success a ->
            tag attributes (accessor (RemoteData.Success a))

        _ ->
            tag attributes (accessor RemoteData.Loading)


h1 : List (Html.Attribute msg) -> (WebData a -> List (Html msg)) -> WebData a -> Html msg
h1 attributes accessor data =
    blanker Html.h1 attributes accessor data


p : List (Html.Attribute msg) -> (WebData a -> List (Html msg)) -> WebData a -> Html msg
p attributes accessor data =
    blanker Html.p attributes accessor data


div : List (Html.Attribute msg) -> (WebData a -> List (Html msg)) -> WebData a -> Html msg
div attributes accessor data =
    blanker Html.div attributes accessor data


text : (a -> String) -> WebData a -> Html msg
text accessor data =
    case data of
        RemoteData.Success a ->
            Html.text (accessor a)

        _ ->
            Html.text "-----"


map : (WebData a -> Html msg) -> WebData (List a) -> List (Html msg)
map fn data =
    case data of
        RemoteData.Success a ->
            List.map fn (List.map RemoteData.Success a)

        _ ->
            List.map fn [ RemoteData.Loading ]
