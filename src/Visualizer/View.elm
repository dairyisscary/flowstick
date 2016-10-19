module Visualizer.View exposing (visualizer)

import Html exposing (..)
import Html.Attributes exposing (..)
import XPDL exposing (..)
import XPDL.Lane exposing (Lanes)
import XPDL.Process exposing (Process)
import Dict exposing (get)
import State exposing (Msg)


lanesHtml : Lanes -> Maybe Process -> Html State.Msg
lanesHtml allLanes currentProcess =
    let
        lanesForCurrentProcess =
            currentProcess
                |> Maybe.map (.lanes)
                |> Maybe.withDefault []

        laneNameFromId laneId =
            get laneId allLanes
                |> Maybe.map (.name)
                |> Maybe.withDefault ""

        rowHtml laneId =
            div [ class "lane" ] [ text (laneNameFromId laneId) ]
    in
        div [ class "lanes" ]
            (List.map rowHtml lanesForCurrentProcess)


loadedVisualizer : XPDLState -> List (Html State.Msg)
loadedVisualizer state =
    let
        currentProcess =
            state.currentProcess `Maybe.andThen` (\id -> get id state.processes)
    in
        [ lanesHtml state.lanes currentProcess ]


visualizer : XPDL -> Html State.Msg
visualizer xpdl =
    let
        wrapper =
            div [ class "visualizer" ]
    in
        case xpdl of
            ErrorLoad err ->
                wrapper [ text ("Error! " ++ err) ]

            NotLoaded ->
                wrapper [ text "Nothing yet!" ]

            Loaded state ->
                wrapper (loadedVisualizer state)
