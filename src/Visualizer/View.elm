module Visualizer.View exposing (visualizer)

import Html exposing (..)
import XPDL exposing (..)
import State exposing (Msg)


getRepr : XPDL -> String
getRepr x =
    case x of
        ErrorLoad a ->
            a

        _ ->
            "error"


loadedVisualizer : XPDLState -> Html State.Msg
loadedVisualizer state =
    div [] [ text (toString state) ]


visualizer : XPDL -> Html State.Msg
visualizer xpdl =
    case xpdl of
        ErrorLoad err ->
            div [] [ text ("Error! " ++ err) ]

        NotLoaded ->
            div [] [ text "Nothing yet!" ]

        Loaded state ->
            loadedVisualizer state
