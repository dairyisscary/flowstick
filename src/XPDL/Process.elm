module XPDL.Process exposing (Processes, Process, ProcessId, processesFromJson)

import Dict exposing (Dict)
import XPDL.Lane exposing (Lanes, LaneId)
import XPDL.Activity exposing (ActivityId)
import XPDL.Transition exposing (TransitionId)
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
    , transitions : List TransitionId
    }


type alias Processes =
    Dict ProcessId Process


processFromJson : Package -> XProc.Process -> Process
processFromJson package xproc =
    let
        procId =
            xproc.id

        pluckId =
            List.map .id

        lanes =
            find (\p -> p.process == procId) package.pools
                |> Maybe.map (pluckId << .lanes)
                |> Maybe.withDefault []
    in
        { id = procId
        , name = xproc.name
        , lanes = lanes
        , activities = pluckId xproc.activities
        , transitions = pluckId xproc.transitions
        }


processesFromJson : Package -> Processes
processesFromJson package =
    createDict (.id) (processFromJson package) package.processes
