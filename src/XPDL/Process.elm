module XPDL.Process exposing (Processes, ProcessId, processesFromJson)

import Dict exposing (..)
import XPDL.Lane exposing (Lanes, LaneId)
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


createDict : (a -> comparable) -> (a -> b) -> List a -> Dict comparable b
createDict pluckFunc func =
    fromList << List.map (\item -> ( pluckFunc item, func item ))


processFromJson : XProc.Process -> Process
processFromJson xproc =
    { id = xproc.id
    , name = xproc.name
    , lanes = []
    }


processesFromJson : Package -> Processes
processesFromJson package =
    createDict (.id) processFromJson package.processes
