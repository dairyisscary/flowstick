module Visualizer.View exposing (visualizer)

import Html exposing (..)
import XPDL exposing (..)
import XPDL.Lane exposing (Lanes)
import XPDL.Process exposing (Process)
import XPDL.Activity exposing (Activities, Activity)
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


activityHtml : Activity -> Html State.Msg
activityHtml act =
    div [] [ text act.id ]


activitiesHtml : Activities -> Maybe Process -> Html State.Msg
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
            in
                Maybe.map activityHtml fullAct

        actHtmls =
            List.map actHtml actsForCurrentProcess |> List.filterMap identity
    in
        div [ ns.class [ Visualizer.Styles.Activities ] ] actHtmls


loadedVisualizer : XPDLState -> List (Html State.Msg)
loadedVisualizer state =
    let
        currentProcess =
            state.currentProcess `Maybe.andThen` (\id -> get id state.processes)
    in
        [ lanesHtml state.lanes currentProcess ] ++ [ activitiesHtml state.activities currentProcess ]


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
