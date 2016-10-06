module XPDL.Lane exposing (Lanes, Lane, lanesDecoder)

import Dict exposing (Dict, fromList)
import Json.Decode exposing (Decoder, string, list)
import Json.Decode.Pipeline exposing (decode, nullable, optional)
import XPDL.Performer exposing (PerformerId)


type alias LaneId =
    String


type alias Lane =
    { id : LaneId
    , name : String
    , performers : List PerformerId
    }


type alias LaneAttributes =
    { id : LaneId, name : String }


type alias Lanes =
    Dict LaneId Lane


laneAttrDecoder : Decoder LaneAttributes
laneAttrDecoder =
    let
        stringFromAttrs =
            Maybe.withDefault ""

        makeAttrs maybeName maybeId =
            { id = stringFromAttrs maybeId, name = stringFromAttrs maybeName }
    in
        decode makeAttrs
            |> optional "Name" (nullable string) Nothing
            |> optional "Id" (nullable string) Nothing


makeLaneFromDecode : Maybe LaneAttributes -> Lane
makeLaneFromDecode maybeAttrs =
    case maybeAttrs of
        Just attrs ->
            -- TODO performers
            Lane attrs.id attrs.name []

        _ ->
            Lane "" "" []


laneDecoder : Decoder Lane
laneDecoder =
    decode makeLaneFromDecode
        |> optional "$" (nullable laneAttrDecoder) Nothing


makeLanesFromDecode : Maybe (List Lane) -> Lanes
makeLanesFromDecode maybeLanes =
    let
        realLanes =
            Maybe.withDefault [] maybeLanes

        lanes =
            List.map (\l -> ( l.id, l )) realLanes
    in
        fromList lanes


lanesDecoder : Decoder Lanes
lanesDecoder =
    decode makeLanesFromDecode
        |> optional "xpdl:Lane" (nullable (list laneDecoder)) Nothing
