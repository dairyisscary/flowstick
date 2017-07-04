module Xpdl.State exposing (XPDL(..), XPDLState)

import Xpdl.Activity exposing (Activities)
import Xpdl.Lane exposing (Lanes)
import Xpdl.Process exposing (Processes, ProcessId)
import Xpdl.Transition exposing (Transitions)


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
