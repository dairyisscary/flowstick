module Visualizer.View exposing (visualizer, laneDimensions)

import Html exposing (..)
import Html.Attributes exposing (..)
import Html.Events exposing (onMouseDown)
import XPDL.Lane exposing (Lanes, Lane, LaneId)
import XPDL.Process exposing (Process)
import XPDL.Activity exposing (Activities, Activity)
import Dict exposing (Dict, get)
import State exposing (Msg(..), DragInfo)
import XPDL.State exposing (XPDLState, XPDL(..))
import Html.CssHelpers exposing (withNamespace)
import Visualizer.Styles exposing (Class(..), namespaceId, activityHeight, activityWidth, leftOffset, topOffset)
import Styles.Namespace exposing (FlowstickNamespace)
import Loader.View exposing (loader)
import Drag exposing (onMouseDownStartDragging)


type alias LaneDimensions =
    { y : Int, height : Int, width : Int }


minLaneHeight : Int
minLaneHeight =
    150


minLaneWidth : Int
minLaneWidth =
    1500


ns : FlowstickNamespace Visualizer.Styles.Class id State.Msg
ns =
    withNamespace namespaceId


laneHtml : LaneDimensions -> Lane -> Html State.Msg
laneHtml laneDims lane =
    div
        [ ns.classList [ ( SystemLane, lane.name == "system" ) ]
        , style
            [ ( "height", toString laneDims.height ++ "px" )
            , ( "width", toString laneDims.width ++ "px" )
            , ( "top", toString (laneDims.y + topOffset) ++ "px" )
            ]
        ]
        [ text lane.name ]


activityPostion : Bool -> number -> number -> String
activityPostion selected dragOffset position =
    let
        pos =
            if selected then
                dragOffset + position
            else
                position
    in
        toString pos ++ "px"


activityHtml : DragInfo -> Dict LaneId LaneDimensions -> Activity -> Html State.Msg
activityHtml dragInfo laneDims act =
    let
        laneDim =
            getLaneDimensionsWithDefault act.lane laneDims

        classes =
            ns.classList [ ( Selected, act.selected ) ]

        mouseDown =
            onMouseDownStartDragging True act.id

        styles =
            style
                [ ( "left", activityPostion act.selected dragInfo.diffX <| act.x + leftOffset )
                , ( "top", activityPostion act.selected dragInfo.diffY <| act.y + laneDim.y + topOffset )
                ]
    in
        div [ styles, classes, mouseDown ] [ text (Maybe.withDefault "" act.name) ]


activitiesHtml : DragInfo -> Dict LaneId LaneDimensions -> Activities -> Process -> List (Html State.Msg)
activitiesHtml dragInfo laneDims acts currentProcess =
    let
        actHtml actId =
            get actId acts |> Maybe.map (activityHtml dragInfo laneDims)
    in
        List.map actHtml currentProcess.activities |> List.filterMap identity


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
        -- We fold assoicating from the left so that the previous accumulations
        -- are from top to bottom.
        List.foldl laneReduction [] lanes
            |> Dict.fromList


loadedProcess : DragInfo -> XPDLState -> Process -> List (Html State.Msg)
loadedProcess dragInfo state process =
    let
        realLanes =
            List.filterMap (\lId -> get lId state.lanes) process.lanes

        realActs =
            List.filterMap (\lId -> get lId state.activities) process.activities

        laneDims =
            laneDimensions realActs realLanes

        laneWidth =
            Dict.values laneDims
                |> List.head
                |> Maybe.map (.width)
                |> Maybe.withDefault minLaneHeight
                |> (+) (2 * leftOffset)
                |> toString

        laneHeight =
            Dict.values laneDims
                |> List.map (.height)
                |> List.sum
                |> (+) (2 * topOffset)
                |> toString

        laneBufferHtml =
            span
                [ ns.class [ LaneBuffer ]
                , style
                    [ ( "width", laneWidth ++ "px" )
                    , ( "height", laneHeight ++ "px" )
                    ]
                ]
                []

        lanesHtml =
            List.map (\lane -> laneHtml (getLaneDimensionsWithDefault lane.id laneDims) lane) realLanes

        actsHtml =
            activitiesHtml dragInfo laneDims state.activities process
    in
        [ h1 [ ns.class [ ProcessTitle ] ] [ text process.name ]
        , div [ ns.class [ Lanes ] ] <| laneBufferHtml :: lanesHtml
        , div [ ns.class [ Visualizer.Styles.Activities ] ] actsHtml
        ]


loadedVisualizer : DragInfo -> XPDLState -> List (Html State.Msg)
loadedVisualizer dragInfo state =
    let
        currentProcess : Maybe Process
        currentProcess =
            state.currentProcess |> Maybe.andThen (\id -> get id state.processes)
    in
        case currentProcess of
            Nothing ->
                [ text "No Process selected yet." ]

            Just process ->
                loadedProcess dragInfo state process


visualizer : State.Model -> Html State.Msg
visualizer model =
    let
        xpdl =
            model.xpdl

        wrapper =
            div [ ns.class [ Visualizer ], onMouseDown DeselectAllActivities ]
    in
        case xpdl of
            ErrorLoad err ->
                wrapper [ text ("Error! " ++ err) ]

            NotLoaded ->
                wrapper [ text "Nothing yet!" ]

            Loading ->
                wrapper [ div [ ns.class [ Loader ] ] [ loader ] ]

            Loaded state ->
                wrapper (loadedVisualizer model.drag state)
