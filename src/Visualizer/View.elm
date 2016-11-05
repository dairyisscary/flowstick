module Visualizer.View exposing (visualizer)

import Html exposing (..)
import Html.Attributes exposing (..)
import XPDL exposing (..)
import XPDL.Lane exposing (Lanes, Lane, LaneId)
import XPDL.Process exposing (Process)
import XPDL.Activity exposing (Activities, Activity)
import Dict exposing (Dict, get)
import State exposing (Msg)
import Html.CssHelpers exposing (Namespace, withNamespace)
import Visualizer.Styles exposing (Class(..), namespaceId, activityHeight, activityWidth)
import Styles.Namespace exposing (FlowstickNamespace)


type alias LaneDimensions =
    { y : Int, height : Int, width : Int }


minLaneHeight : Int
minLaneHeight =
    150


minLaneWidth : Int
minLaneWidth =
    1500


ns : FlowstickNamespace Class id State.Msg
ns =
    withNamespace namespaceId


laneHtml : LaneDimensions -> Lane -> Html State.Msg
laneHtml laneDims lane =
    div
        [ ns.classList [ ( SystemLane, lane.name == "system" ) ]
        , style
            [ ( "height", toString laneDims.height ++ "px" )
            , ( "width", toString laneDims.width ++ "px" )
            ]
        ]
        [ span [] [ text lane.name ] ]


activityHtml : Dict LaneId LaneDimensions -> Activity -> Html State.Msg
activityHtml laneDims act =
    let
        laneDim =
            getLaneDimensionsWithDefault act.lane laneDims

        thisActY =
            act.y + laneDim.y

        styles =
            style
                [ ( "left", toString act.x ++ "px" )
                , ( "top", toString thisActY ++ "px" )
                ]
    in
        div [ styles ] [ text (Maybe.withDefault "" act.name) ]


activitiesHtml : Dict LaneId LaneDimensions -> Activities -> Process -> Html State.Msg
activitiesHtml laneDims acts currentProcess =
    let
        actHtml actId =
            get actId acts |> Maybe.map (activityHtml laneDims)

        actHtmls =
            List.map actHtml currentProcess.activities |> List.filterMap identity
    in
        div [ ns.class [ Visualizer.Styles.Activities ] ] actHtmls


getLaneDimensionsWithDefault : LaneId -> Dict LaneId LaneDimensions -> LaneDimensions
getLaneDimensionsWithDefault laneId laneDims =
    get laneId laneDims
        |> Maybe.withDefault { y = 0, height = minLaneHeight, width = minLaneWidth }


laneDimensions : List Activity -> List Lane -> Dict LaneId LaneDimensions
laneDimensions acts lanes =
    let
        actMax func laneId act accum =
            if act.lane /= laneId || func act < accum then
                accum
            else
                func act

        activityRight =
            List.map (.x) acts
                |> List.maximum
                |> Maybe.withDefault minLaneWidth
                |> (+) (activityWidth + 15)

        activityBottom lane =
            -- Minimum height is starting accum:
            -- TODO make these contants
            List.foldr (actMax (.y) lane.id) minLaneHeight acts
                |> (+) (activityHeight + 15)

        laneReduction lane accum =
            let
                prevLaneY =
                    List.head accum
                        |> Maybe.map (\( _, { y, height } ) -> y + height)
                        |> Maybe.withDefault 0

                item =
                    ( lane.id
                    , { height = activityBottom lane
                      , y = prevLaneY
                      , width = activityRight
                      }
                    )
            in
                item :: accum
    in
        List.foldr laneReduction [] lanes
            |> Dict.fromList


loadedProcess : XPDLState -> Process -> List (Html State.Msg)
loadedProcess state process =
    let
        realLanes =
            List.filterMap (\lId -> get lId state.lanes) process.lanes

        realActs =
            List.filterMap (\lId -> get lId state.activities) process.activities

        laneDims =
            laneDimensions realActs realLanes

        lanesHtml =
            List.map (\lane -> laneHtml (getLaneDimensionsWithDefault lane.id laneDims) lane) realLanes
    in
        [ div [ ns.class [ Lanes ] ] lanesHtml ]
            ++ [ activitiesHtml laneDims state.activities process ]


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
