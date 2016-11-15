module Main exposing (..)

import Html
import State exposing (Model, Msg, init, update, subscriptions)
import View exposing (view)


main : Program Never Model Msg
main =
    Html.program
        { init = init
        , view = view
        , update = update
        , subscriptions = subscriptions
        }
