module Main exposing (..)

import Html.App
import State exposing (Model, Msg, init, update, subscriptions)
import View exposing (view)


main : Program Never
main =
    Html.App.program
        { init = init
        , view = view
        , update = update
        , subscriptions = subscriptions
        }
