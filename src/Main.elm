module Main exposing (..)

import Html
import History exposing (History)
import State exposing (Model, Msg)
import Update exposing (init, update, subscriptions)
import View exposing (view)


main : Program Never (History Model) Msg
main =
    Html.program
        { init = init
        , view = view
        , update = update
        , subscriptions = subscriptions
        }
