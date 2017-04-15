module XPDL.Lane exposing (Lanes, Lane, LaneId, Performer, lanesFromJson)

import Dict exposing (..)
import Json.Decode.Xpdl.Package exposing (Package)
import Json.Decode.Xpdl.Pool exposing (Pools)
import XPDL.Extra exposing (createDict)
import XPDL.Extra exposing (createDict)


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


lanesFromJson : Package -> Lanes
lanesFromJson package =
    createDict (.id) identity (List.concatMap (.lanes) package.pools)
