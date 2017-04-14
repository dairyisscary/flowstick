module Json.XPDL.Lane exposing (Lanes, Lane, LaneId, lanesDecoder)

import Json.Decode exposing (..)
import Json.Decode.Maybe exposing (maybeWithDefault)
import Json.Decode.XML exposing (listOfOne)
import Json.XPDL.Performer exposing (performerDecoder, Performer)


type alias LaneId =
    String


type alias LaneAttributes =
    { id : LaneId, name : String }


type alias Lane =
    { id : LaneId
    , name : String
    , performer : Performer
    }


type alias Lanes =
    List Lane


laneAttrDecoder : Decoder LaneAttributes
laneAttrDecoder =
    map2 LaneAttributes
        (field "Id" string)
        (maybeWithDefault "" (field "Name" string))


makeLaneFromDecode : LaneAttributes -> Performer -> Lane
makeLaneFromDecode { id, name } =
    Lane id name


laneDecoder : Decoder Lane
laneDecoder =
    map2 makeLaneFromDecode
        (field "$" laneAttrDecoder)
        (maybeWithDefault "" (field "xpdl:Performers" (listOfOne performerDecoder)))


lanesDecoder : Decoder Lanes
lanesDecoder =
    maybeWithDefault [] (field "xpdl:Lane" (list laneDecoder))
