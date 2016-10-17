module XPDL.Process exposing (Processes, ProcessId, processesFromJson)

import Dict exposing (Dict)
import XPDL.Lane exposing (Lanes, LaneId)
import XPDL.Extra exposing (createDict, find)
import Json.XPDL.Package exposing (Package)
import Json.XPDL.Process as XProc


type alias ProcessId =
    String


type alias Process =
    { id : ProcessId
    , name : String
    , lanes : List LaneId
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
            maybePools `Maybe.andThen` (Just << .lanes)

        lanes =
            maybeLanes `Maybe.andThen` (Just << List.map .id)
    in
        { id = procId
        , name = xproc.name
        , lanes = Maybe.withDefault [] lanes
        }


processesFromJson : Package -> Processes
processesFromJson package =
    createDict (.id) (processFromJson package) package.processes
