module XPDL.Process exposing (Processes, ProcessId)

import Dict exposing (..)
import XPDL.Lane exposing (Lanes)


type alias ProcessId =
    String


type alias Process =
    { id : ProcessId
    , name : String
    , lanes : Lanes
    }


type alias Processes =
    Dict ProcessId Process
