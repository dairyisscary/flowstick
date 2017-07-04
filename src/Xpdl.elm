module Xpdl exposing (initialXPDL, update, subscriptions)

import Dict exposing (update, get, map)
import Drag exposing (draggingData)
import Json.Decode.Xpdl as JDX
import List.Extra exposing (find)
import State exposing (Msg(..), Model, DragInfo)
import Visualizer.View exposing (laneDimensions)
import Xpdl.Activity exposing (Activity, ActivityId, activitiesFromJson)
import Xpdl.File as File
import Xpdl.Lane exposing (LaneId, lanesFromJson)
import Xpdl.Process exposing (ProcessId, processesFromJson)
import Xpdl.State exposing (XPDL(..), XPDLState)
import Xpdl.Transition exposing (TransitionId)


initialXPDL : XPDL
initialXPDL =
    NotLoaded


convertJsonToState : JDX.XPDLResult -> XPDL
convertJsonToState jxpdl =
    case jxpdl of
        Ok package ->
            Loaded
                { processes = processesFromJson package
                , entries = List.map (.id) package.processes
                , lanes = lanesFromJson package
                , currentProcess = Nothing
                , activities = activitiesFromJson package
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


deselectAll : XPDLState -> XPDLState
deselectAll state =
    let
        unselect x =
            { x | selected = False }

        unselectTransition _ trans =
            unselect { trans | anchors = List.map unselect trans.anchors }

        unselectedTransitions _ process =
            { process | transitions = Dict.map unselectTransition process.transitions }
    in
        { state
            | activities = Dict.map (\_ act -> unselect act) state.activities
            , processes = Dict.map unselectedTransitions state.processes
        }


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

        moveAnchors =
            -- We _always_ turn off anchor selection on stop dragging
            List.map
                (\anchor ->
                    if anchor.selected then
                        { anchor
                            | x = anchor.x + draggingData dragInfo .diffX 0 |> max 0
                            , y = anchor.y + draggingData dragInfo .diffY 0 |> max 0
                            , selected = False
                        }
                    else
                        { anchor | selected = False }
                )

        moveSelectedAnchors =
            Dict.map
                (\_ transition ->
                    if transition.selected then
                        { transition | anchors = moveAnchors transition.anchors }
                    else
                        transition
                )

        movedProcessTransitions =
            Dict.map (\_ proc -> { proc | transitions = moveSelectedAnchors proc.transitions }) state.processes
    in
        { state | activities = movedActs, processes = movedProcessTransitions }


selectTransitionAndAnchor : ProcessId -> TransitionId -> Maybe Int -> XPDLState -> XPDLState
selectTransitionAndAnchor procId transId maybeAnchorIndex state =
    let
        selectAnchor index anchor =
            if Just index == maybeAnchorIndex then
                { anchor | selected = True }
            else
                anchor

        turnOnSelection transition =
            { transition
                | selected = True
                , anchors = List.indexedMap selectAnchor transition.anchors
            }

        selectTransitionInProc process =
            { process | transitions = Dict.update transId (Maybe.map turnOnSelection) process.transitions }
    in
        { state | processes = Dict.update procId (Maybe.map selectTransitionInProc) state.processes }


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
                ( selectOne <| modifyLoaded deselectAll model.xpdl, Cmd.none )

        SelectTransition procId transId maybeAnchorIndex _ ->
            ( modifyLoaded deselectAll model.xpdl
                |> modifyLoaded (selectTransitionAndAnchor procId transId maybeAnchorIndex)
            , Cmd.none
            )

        ChangeCurrentProcess newProcId ->
            ( modifyLoaded (\s -> { s | currentProcess = Just newProcId }) model.xpdl, Cmd.none )

        DeselectAll ->
            ( modifyLoaded deselectAll model.xpdl, Cmd.none )

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
