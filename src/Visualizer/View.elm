module Visualizer.View exposing (visualizer)

import Html exposing (..)
import XPDL exposing (..)
import XPDL.Lane exposing (Lanes)
import XPDL.Process exposing (Process)
import XPDL.Activity exposing (Activities)
import Dict exposing (get)
import State exposing (Msg)
import Html.CssHelpers exposing (Namespace, withNamespace)
import Visualizer.Styles exposing (Class(..), namespaceId)
import Styles.Namespace exposing (FlowstickNamespace)


ns : FlowstickNamespace Class id State.Msg
ns =
    withNamespace namespaceId


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
            let
                laneName =
                    laneNameFromId laneId
            in
                div
                    [ ns.classList
                        [ ( SystemLane, laneName == "system" )
                        ]
                    ]
                    [ span [] [ text laneName ] ]
    in
        div [ ns.class [ Lanes ] ]
            (List.map rowHtml lanesForCurrentProcess)


activitiesHtml : Activities -> Maybe Process -> List (Html State.Msg)
activitiesHtml allActs currentProcess =
    let
        actsForCurrentProcess =
            currentProcess
                |> Maybe.map (.activities)
                |> Maybe.withDefault []

        actHtml actId =
            let
                fullAct =
                    get actId allActs

                actName =
                    Maybe.withDefault "" (fullAct `Maybe.andThen` .name)
            in
                div [] [ text actName ]
    in
        List.map actHtml actsForCurrentProcess


loadedVisualizer : XPDLState -> List (Html State.Msg)
loadedVisualizer state =
    let
        currentProcess =
            state.currentProcess `Maybe.andThen` (\id -> get id state.processes)
    in
        [ lanesHtml state.lanes currentProcess ] ++ (activitiesHtml state.activities currentProcess)


visualizer : XPDL -> Html State.Msg
visualizer xpdl =
    let
        wrapper =
            div [ ns.class [ Visualizer ] ]
    in
        case xpdl of
            ErrorLoad err ->
                wrapper [ text ("Error! " ++ err) ]

            NotLoaded ->
                wrapper [ text "Nothing yet!" ]

            Loaded state ->
                wrapper (loadedVisualizer state)
