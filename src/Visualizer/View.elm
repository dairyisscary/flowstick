module Visualizer.View exposing (visualizer)

import Html exposing (..)
import Html.Attributes exposing (..)
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


lanesHtml : Lanes -> Process -> Html State.Msg
lanesHtml allLanes currentProcess =
    let
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
            (List.map rowHtml currentProcess.lanes)


activityHtml : Activity -> Html State.Msg
activityHtml act =
    let
        styles =
            style
                [ ( "left", toString act.x ++ "px" )
                , ( "top", toString act.y ++ "px" )
                ]
    in
        div [ styles ] [ text (Maybe.withDefault "" act.name) ]


activitiesHtml : Activities -> Process -> Html State.Msg
activitiesHtml acts currentProcess =
    let
        actHtml actId =
            get actId acts |> Maybe.map activityHtml

        actHtmls =
            List.map actHtml currentProcess.activities |> List.filterMap identity
    in
        div [ ns.class [ Visualizer.Styles.Activities ] ] actHtmls


loadedVisualizer : XPDLState -> List (Html State.Msg)
loadedVisualizer state =
    let
        currentProcess : Maybe Process
        currentProcess =
            state.currentProcess `Maybe.andThen` (\id -> get id state.processes)
    in
        case currentProcess of
            Nothing ->
                [ text "No Process selected yet." ]

            Just process ->
                [ lanesHtml state.lanes process ] ++ [ activitiesHtml state.activities process ]


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
