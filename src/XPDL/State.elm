module XPDL.State exposing (XPDL(..), XPDLState)

import XPDL.Process exposing (Processes, ProcessId)
import XPDL.Lane exposing (Lanes)
import XPDL.Activity exposing (Activities)
import XPDL.Transition exposing (Transitions)


type alias XPDLState =
    { processes : Processes
    , entries : List ProcessId
    , lanes : Lanes
    , activities : Activities
    , currentProcess : Maybe ProcessId
    , transitions : Transitions
    }


type XPDL
    = NotLoaded
    | Loading
    | Loaded XPDLState
    | ErrorLoad String
