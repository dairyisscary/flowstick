module XPDL.Process exposing (Processes, Process, ProcessId, processesFromJson)

import Dict exposing (Dict)
import XPDL.Lane exposing (Lanes, LaneId)
import XPDL.Activity exposing (ActivityId)
import List.Extra exposing (find)
import XPDL.Extra exposing (createDict)
import Json.XPDL.Package exposing (Package)
import Json.XPDL.Process as XProc


type alias ProcessId =
    String


type alias Process =
    { id : ProcessId
    , name : String
    , lanes : List LaneId
    , activities : List ActivityId
    }


type alias Processes =
    Dict ProcessId Process


processFromJson : Package -> XProc.Process -> Process
processFromJson package xproc =
    let
        procId =
            xproc.id

        maybePools =
            find (\p -> p.process == procId) package.pools

        maybeLanes =
            maybePools |> Maybe.andThen (Just << .lanes)

        lanes =
            maybeLanes |> Maybe.andThen (Just << List.map .id)
    in
        { id = procId
        , name = xproc.name
        , lanes = Maybe.withDefault [] lanes
        , activities = List.map (.id) xproc.activities
        }


processesFromJson : Package -> Processes
processesFromJson package =
    createDict (.id) (processFromJson package) package.processes
