module Xpdl exposing (initialXPDL, update, subscriptions)

import Dict exposing (update, get, map)
import Drag exposing (draggingData)
import Json.Decode.Xpdl as JDX
import List.Extra exposing (find)
import State exposing (Msg(..), Model, DragInfo(Dragging))
import Visualizer.View exposing (laneDimensions)
import Xpdl.Activity exposing (Activity, ActivityId, activitiesFromJson)
import Xpdl.File as File
import Xpdl.Lane exposing (LaneId, lanesFromJson)
import Xpdl.Process exposing (processesFromJson)
import Xpdl.State exposing (XPDL(..), XPDLState)
import Xpdl.Transition exposing (transitionsFromJson)


initialXPDL : XPDL
initialXPDL =
    NotLoaded


convertJsonToState : JDX.XPDL -> XPDL
convertJsonToState jxpdl =
    case jxpdl of
        Ok package ->
            Loaded
                { processes = processesFromJson package
                , entries = List.map (.id) package.processes
                , lanes = lanesFromJson package
                , currentProcess = Nothing
                , activities = activitiesFromJson package
                , transitions = transitionsFromJson package
                }

        Err str ->
            ErrorLoad str


jsonUpdate : JDX.Msg -> XPDL -> ( XPDL, Cmd a )
jsonUpdate msg model =
    let
        ( jsonXpdl, jsonCmd ) =
            JDX.handleMessage msg

        newXpdl =
            Maybe.withDefault Loading (jsonXpdl |> Maybe.andThen (Just << convertJsonToState))
    in
        ( newXpdl, jsonCmd )


modifyLoaded : (XPDLState -> XPDLState) -> XPDL -> XPDL
modifyLoaded fn xpdl =
    case xpdl of
        Loaded state ->
            Loaded <| fn state

        _ ->
            xpdl


modifyAct : (Activity -> Activity) -> ActivityId -> XPDL -> XPDL
modifyAct fn id xpdl =
    let
        updateAct state =
            { state | activities = Dict.update id (Maybe.andThen <| Just << fn) state.activities }
    in
        modifyLoaded updateAct xpdl


deselectAllActivites : XPDLState -> XPDLState
deselectAllActivites state =
    let
        unselectedActs =
            Dict.map (\_ a -> { a | selected = False }) state.activities
    in
        { state | activities = unselectedActs }


computeNewLaneAndCords : List ( LaneId, Int ) -> DragInfo -> Activity -> Activity
computeNewLaneAndCords laneYs dragInfo act =
    let
        currentLaneY =
            find ((==) act.lane << Tuple.first) laneYs
                |> Maybe.map Tuple.second
                |> Maybe.withDefault 0

        totalActivityY =
            act.y + draggingData dragInfo .diffY 0 + currentLaneY

        laneFinder laneInfo accum =
            if Tuple.second laneInfo < totalActivityY then
                laneInfo
            else
                accum

        sortedLanes =
            List.sortBy Tuple.second laneYs

        defaultLaneInfo =
            List.head sortedLanes |> Maybe.withDefault ( act.lane, currentLaneY )

        newLane =
            List.foldl laneFinder defaultLaneInfo sortedLanes
    in
        { act
            | x = act.x + draggingData dragInfo .diffX 0 |> max 0
            , y = totalActivityY - Tuple.second newLane |> max 0
            , lane = Tuple.first newLane
        }


addOffsets : DragInfo -> XPDLState -> XPDLState
addOffsets dragInfo state =
    let
        realCurrentProcess =
            state.currentProcess |> Maybe.andThen (\id -> get id state.processes)

        procProp procPropFn statePropFn =
            Maybe.map procPropFn realCurrentProcess
                |> Maybe.map (List.filterMap (\id -> get id (statePropFn state)))
                |> Maybe.withDefault []

        laneDims =
            laneDimensions (procProp (.activities) (.activities)) (procProp (.lanes) (.lanes))
                |> Dict.toList
                |> List.map (\( laneId, laneDims ) -> ( laneId, laneDims.y ))

        moveAct _ act =
            if act.selected then
                computeNewLaneAndCords laneDims dragInfo act
            else
                act

        movedActs =
            Dict.map moveAct state.activities
    in
        { state | activities = movedActs }


update : Msg -> Model -> ( XPDL, Cmd a )
update msg model =
    case msg of
        JSONMsg jmsg ->
            jsonUpdate jmsg model.xpdl

        FileMsg fmsg ->
            ( model.xpdl, File.handleMessage fmsg )

        SelectActivity actId _ ->
            let
                selectOne =
                    modifyAct (\a -> { a | selected = True }) actId
            in
                ( selectOne <| modifyLoaded deselectAllActivites model.xpdl, Cmd.none )

        ChangeCurrentProcess newProcId ->
            ( modifyLoaded (\s -> { s | currentProcess = Just newProcId }) model.xpdl, Cmd.none )

        DeselectAllActivities ->
            ( modifyLoaded deselectAllActivites model.xpdl, Cmd.none )

        StopDragging ->
            ( modifyLoaded (addOffsets model.drag) model.xpdl, Cmd.none )

        _ ->
            ( model.xpdl, Cmd.none )


subscriptions : XPDL -> Sub Msg
subscriptions _ =
    Sub.batch
        [ Sub.map JSONMsg JDX.subscriptions
        , Sub.map JSONMsg File.subscriptions
        ]
