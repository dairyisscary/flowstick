module Visualizer.View exposing (visualizer)

import Html exposing (..)
import Html.Attributes exposing (..)
import XPDL exposing (..)
import XPDL.Lane exposing (Lanes, Lane)
import XPDL.Process exposing (Process)
import XPDL.Activity exposing (Activities, Activity)
import Dict exposing (get)
import State exposing (Msg)
import Html.CssHelpers exposing (Namespace, withNamespace)
import Visualizer.Styles exposing (Class(..), namespaceId, activityHeight)
import Styles.Namespace exposing (FlowstickNamespace)


ns : FlowstickNamespace Class id State.Msg
ns =
    withNamespace namespaceId


laneHtml : List Activity -> Lane -> Html State.Msg
laneHtml acts lane =
    let
        reduction act accum =
            if act.lane /= lane.id || act.y < accum then
                accum
            else
                act.y

        activityBottom =
            -- Minimum height is starting accum:
            List.foldr reduction 150 acts
                |> (+) (activityHeight + 15)
                |> toString
    in
        div
            [ ns.classList [ ( SystemLane, lane.name == "system" ) ]
            , style [ ( "height", activityBottom ++ "px" ) ]
            ]
            [ span [] [ text lane.name ] ]


lanesHtml : XPDLState -> Process -> Html State.Msg
lanesHtml state currentProcess =
    let
        realLanes =
            List.filterMap (\lId -> get lId state.lanes) currentProcess.lanes

        realActs =
            List.filterMap (\lId -> get lId state.activities) currentProcess.activities

        lanesHtml =
            List.map (laneHtml realActs) realLanes
    in
        div [ ns.class [ Lanes ] ] lanesHtml


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
                [ lanesHtml state process ] ++ [ activitiesHtml state.activities process ]


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
