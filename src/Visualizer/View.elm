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


laneHtml : String -> Lane -> Html State.Msg
laneHtml activityBottom lane =
    div
        [ ns.classList [ ( SystemLane, lane.name == "system" ) ]
        , style [ ( "height", activityBottom ++ "px" ) ]
        ]
        [ span [] [ text lane.name ] ]


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


loadedProcess : XPDLState -> Process -> List (Html State.Msg)
loadedProcess state process =
    let
        realLanes =
            List.filterMap (\lId -> get lId state.lanes) process.lanes

        realActs =
            List.filterMap (\lId -> get lId state.activities) process.activities

        reduction laneId act accum =
            if act.lane /= laneId || act.y < accum then
                accum
            else
                act.y

        activityBottom lane =
            -- Minimum height is starting accum:
            List.foldr (reduction lane.id) 150 realActs
                |> (+) (activityHeight + 15)
                |> toString

        lanesHtml =
            List.map (\lane -> laneHtml (activityBottom lane) lane) realLanes
    in
        [ div [ ns.class [ Lanes ] ] lanesHtml ]
            ++ [ activitiesHtml state.activities process ]


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
                loadedProcess state process


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
