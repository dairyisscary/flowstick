module Header.View exposing (header)

import Html exposing (..)
import Html.Events exposing (onClick)
import XPDL exposing (Msg(..))
import XPDL.File exposing (Msg(..))
import State exposing (Model, Msg)


buttons : Model -> Html State.Msg
buttons model =
    button [ onClick (State.XPDLMsg (FileMsg OpenFileDialog)) ] [ text "Open" ]


header : Model -> List (Html State.Msg)
header model =
    [ buttons model ]
