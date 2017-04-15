module Xpdl.Process exposing (Processes, Process, ProcessId, processesFromJson)

import Dict exposing (Dict)
import Json.Decode.Xpdl.Package exposing (Package)
import Json.Decode.Xpdl.Process as XProc
import List.Extra exposing (find)
import Xpdl.Activity exposing (ActivityId)
import Xpdl.Extra exposing (createDict)
import Xpdl.Lane exposing (Lanes, LaneId)
import Xpdl.Transition exposing (TransitionId)


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
