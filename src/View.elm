module View exposing (view)

import Html exposing (..)
import Html.Attributes exposing (..)
import Html.Events exposing (..)
import XPDL.File exposing (Msg(..))
import XPDL exposing (Msg(..))
import State exposing (Model, Msg)
import Visualizer.View exposing (visualizer)


view : Model -> Html State.Msg
view model =
    div []
        [ button [ onClick (State.XPDLMsg (FileMsg OpenFileDialog)) ] [ text "Load!" ]
        , visualizer model.xpdl
        ]
