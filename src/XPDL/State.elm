module XPDL.State exposing (XPDL(..), XPDLState)

import XPDL.Process exposing (Processes, ProcessId)
import XPDL.Lane exposing (Lanes)
import XPDL.Activity exposing (Activities)


type alias XPDLState =
    { processes : Processes
    , entries : List ProcessId
    , lanes : Lanes
    , activities : Activities
    , currentProcess : Maybe ProcessId
    }


type XPDL
    = NotLoaded
    | Loading
    | Loaded XPDLState
    | ErrorLoad String
