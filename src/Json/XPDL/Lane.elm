module Json.XPDL.Lane exposing (Lanes, lanesDecoder)

import XPDL.Lane exposing (LaneId, Lane, Performer)
import Json.Decode exposing (Decoder, string, list)
import Json.Decode.Pipeline exposing (decode, nullable, optional, required)
import Json.Decode.XML exposing (listOfOne)
import Json.XPDL.Performer exposing (performerDecoder)


type alias LaneAttributes =
    { id : LaneId, name : String }


type alias Lanes =
    List Lane


laneAttrDecoder : Decoder LaneAttributes
laneAttrDecoder =
    decode (\id name -> { id = id, name = name })
        |> required "Id" string
        |> optional "Name" string ""


makeLaneFromDecode : LaneAttributes -> Performer -> Lane
makeLaneFromDecode attrs =
    Lane attrs.id attrs.name


laneDecoder : Decoder Lane
laneDecoder =
    decode makeLaneFromDecode
        |> required "$" laneAttrDecoder
        |> optional "xpdl:Performers" (listOfOne performerDecoder) ""


lanesDecoder : Decoder Lanes
lanesDecoder =
    decode identity
        |> optional "xpdl:Lane" (list laneDecoder) []
