module XPDL.Lane exposing (Lanes, Lane, LaneId, Performer)

import Dict exposing (..)


type alias Performer =
    String


type alias LaneId =
    String


type alias Lane =
    { id : LaneId
    , name : String
    , performer : Performer
    }


type alias Lanes =
    Dict LaneId Lane
