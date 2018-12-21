module Main exposing (..)

import Blankable
import Browser
import Html exposing (Html, button, div, form, h1, input, text)
import Html.Events exposing (onClick, onInput, onSubmit)
import Http exposing (expectJson)
import Json.Decode exposing (Decoder, field, string)
import RemoteData exposing (WebData)


main =
    Browser.element { init = init, update = update, view = view, subscriptions = subscriptions }


type alias Flags =
    {}


type alias Post =
    { title : String
    , subTitle : String
    , body : String
    , author : String
    }


subscriptions model =
    Sub.none


type alias Model =
    { post : WebData (List Post)
    , loading : Bool
    }


init : Flags -> ( Model, Cmd Msg )
init _ =
    ( Model RemoteData.Loading True, Cmd.none )


type Msg
    = UpdateSearch String
    | Search
    | PostResponse (WebData (List Post))


postData : WebData (List Post)
postData =
    RemoteData.Success [ Post "First Post" "welcome to my blog" "this part is real long. maybe it goes on for like 5 or 6 lines at the most. this part is real long. maybe it goes on for like 5 or 6 lines at the most. this part is real long. maybe it goes on for like 5 or 6 lines at the most." "Mr. Blogger" ]


postNoData : WebData (List Post)
postNoData =
    RemoteData.Loading


update msg model =
    case msg of
        UpdateSearch newSearch ->
            ( { model | post = postNoData }, Cmd.none )

        Search ->
            ( { model | post = postData }, Cmd.none )

        PostResponse response ->
            ( { model | post = response }, Cmd.none )


view model =
    div []
        [ form [ onSubmit Search ]
            [ input [ onInput UpdateSearch ] []
            ]
        , div [] [ viewPosts model.post ]
        , div [] [ text <| Debug.toString model ]
        ]


viewPosts : WebData (List Post) -> Html Msg
viewPosts posts =
    div [] (Blankable.map wdPost posts)


wdPost : WebData Post -> Html Msg
wdPost blankablePost =
    Blankable.div []
        (\post ->
            [ Blankable.h1 [] (\apost -> [ Blankable.text (\p -> p.title) apost ]) post
            , Blankable.p [] (\apost -> [ Blankable.text (\p -> p.body) apost ]) post
            ]
        )
        blankablePost
