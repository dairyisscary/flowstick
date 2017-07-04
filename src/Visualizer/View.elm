module Visualizer.View exposing (visualizer, laneDimensions)

import Dict exposing (Dict, get)
import Drag exposing (onMouseDownStartDragging, draggingData)
import Html exposing (..)
import Html.Attributes exposing (..)
import Html.CssHelpers exposing (withNamespace)
import Html.Events exposing (onMouseDown)
import Loader.View exposing (loader)
import State exposing (Msg(..), DragInfo(Dragging))
import Styles.Icons exposing (IconSize(XSmall), icon)
import Styles.Namespace exposing (FlowstickNamespace)
import Visualizer.Styles exposing (..)
import Xpdl.Activity exposing (Activities, Activity)
import Xpdl.Lane exposing (Lanes, Lane, LaneId)
import Xpdl.Process exposing (Process, ProcessId)
import Xpdl.State exposing (XPDLState, XPDL(..))
import Xpdl.Transition exposing (TransitionId, Transitions, Transition)


type alias Position =
    { top : Float, left : Float }


type alias LaneDimensions =
    { y : Int, height : Int, width : Int }


type alias Segment =
    { left : Float
    , top : Float
    , width : Float
    , angle : Float
    }


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


activityPosition : DragInfo -> Dict LaneId LaneDimensions -> Activity -> Position
activityPosition dragInfo laneDims act =
    let
        laneDim =
            getLaneDimensionsWithDefault act.lane laneDims

        addDragOffset fn position =
            if act.selected then
                draggingData dragInfo fn 0 + position
            else
                position

        left =
            addDragOffset .diffX (act.x + leftOffset)

        top =
            addDragOffset .diffY (act.y + laneDim.y + topOffset)
    in
        { top = toFloat top, left = toFloat left }


activityHtml : DragInfo -> Dict LaneId LaneDimensions -> Activity -> Html State.Msg
activityHtml dragInfo laneDims act =
    let
        classes =
            ns.classList [ ( Selected, act.selected ) ]

        mouseDown =
            onMouseDownStartDragging True (SelectActivity act.id)

        pos =
            activityPosition dragInfo laneDims act

        styles =
            style [ ( "left", toString pos.left ++ "px" ), ( "top", toString pos.top ++ "px" ) ]
    in
        div [ styles, classes, mouseDown ] [ text (Maybe.withDefault "" act.name) ]


activitiesHtml : DragInfo -> Dict LaneId LaneDimensions -> Activities -> Process -> List (Html State.Msg)
activitiesHtml dragInfo laneDims acts currentProcess =
    let
        htmlGen =
            activityHtml dragInfo laneDims

        actHtml actId =
            get actId acts |> Maybe.map htmlGen
    in
        List.filterMap actHtml currentProcess.activities


computeSegment : Float -> Float -> Float -> Float -> Segment
computeSegment x1 y1 x2 y2 =
    let
        length =
            sqrt <| (x2 - x1) ^ 2 + (y2 - y1) ^ 2

        left =
            (x1 + x2) / 2 - length / 2

        top =
            (y1 + y2) / 2 - transitionThickness / 2

        angle =
            atan2 (y1 - y2) (x1 - x2) * (180 / pi)
    in
        { left = left, top = top, width = length, angle = angle }


segmentsHtml : ProcessId -> TransitionId -> List Segment -> List (Html State.Msg)
segmentsHtml procId transId segments =
    let
        styles seg =
            style
                [ ( "left", toString seg.left ++ "px" )
                , ( "top", toString seg.top ++ "px" )
                , ( "width", toString seg.width ++ "px" )
                , ( "transform", "rotate(" ++ toString seg.angle ++ "deg)" )
                ]

        mouseDown anchorIndex =
            onMouseDownStartDragging True (SelectTransition procId transId anchorIndex)

        anchor anchorIndex =
            div [ mouseDown <| Just (anchorIndex - 1) ] [ icon "radio_button_checked" XSmall ]

        segmentMouseDown =
            mouseDown Nothing

        segmentHtml index seg =
            if index == 0 then
                div [ styles seg, segmentMouseDown ] []
            else
                div [ styles seg, segmentMouseDown ] [ anchor index ]
    in
        List.indexedMap segmentHtml segments


transitionHtml :
    ProcessId
    -> DragInfo
    -> Activities
    -> Dict LaneId LaneDimensions
    -> Transition
    -> Maybe (Html State.Msg)
transitionHtml procId dragInfo acts laneDims trans =
    let
        centerActivityPosition pos =
            { top = pos.top + activityHeight / 2, left = pos.left + activityWidth / 2 }

        centerActivityPositionFromActId actId =
            get actId acts
                |> Maybe.map (activityPosition dragInfo laneDims)
                |> Maybe.map centerActivityPosition

        draggingOffsets =
            if trans.selected then
                { x = toFloat <| draggingData dragInfo .diffX 0
                , y = toFloat <| draggingData dragInfo .diffY 0
                }
            else
                { x = 0, y = 0 }

        anchorPostions =
            List.map
                (\{ x, y, selected } ->
                    { left =
                        toFloat x
                            + leftOffset
                            + if selected then
                                draggingOffsets.x
                              else
                                0
                    , top =
                        toFloat y
                            + topOffset
                            + if selected then
                                draggingOffsets.y
                              else
                                0
                    }
                )
                trans.anchors

        listOfSegments : Position -> Position -> List Segment
        listOfSegments fromActPos toActPos =
            List.map2 (,) (fromActPos :: anchorPostions) (anchorPostions ++ [ toActPos ])
                |> List.map (\( f, t ) -> computeSegment f.left f.top t.left t.top)

        allSegments : Maybe (List Segment)
        allSegments =
            Maybe.map2
                listOfSegments
                (centerActivityPositionFromActId trans.from)
                (centerActivityPositionFromActId trans.to)

        wrapper segments =
            segmentsHtml procId trans.id segments
                |> div [ ns.classList [ ( Selected, trans.selected ) ] ]
    in
        Maybe.map wrapper allSegments


transistionsHtml : DragInfo -> Dict LaneId LaneDimensions -> XPDLState -> Process -> List (Html State.Msg)
transistionsHtml dragInfo laneDims state currentProcess =
    Dict.values currentProcess.transitions
        |> List.filterMap (transitionHtml currentProcess.id dragInfo state.activities laneDims)


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

        transHtml =
            transistionsHtml dragInfo laneDims state process
    in
        [ h1 [ ns.class [ ProcessTitle ] ] [ text process.name ]
        , div [ ns.class [ Lanes ] ] <| laneBufferHtml :: lanesHtml
        , div [ ns.class [ Visualizer.Styles.Activities ] ] actsHtml
        , div [ ns.class [ Transitions ] ] transHtml
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
            div [ ns.class [ Visualizer ], onMouseDown DeselectAll ]
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
