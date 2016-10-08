module XPDL.Lane exposing (Lanes, Lane, LaneId, lanesDecoder)

import Dict exposing (Dict, fromList)
import Json.Decode exposing (Decoder, string, list)
import Json.Decode.Pipeline exposing (decode, nullable, optional)
import XPDL.Performer exposing (Performer, performerDecoder)


type alias LaneId =
    String


type alias Lane =
    { id : LaneId
    , name : String
    , performer : Performer
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


makeLaneFromDecode : Maybe LaneAttributes -> Maybe (List Performer) -> Lane
makeLaneFromDecode maybeAttrs maybePerf =
    let
        performers =
            Maybe.withDefault "" (maybePerf `Maybe.andThen` List.head)
    in
        case maybeAttrs of
            Just attrs ->
                Lane attrs.id attrs.name performers

            _ ->
                Lane "" "" ""


laneDecoder : Decoder Lane
laneDecoder =
    decode makeLaneFromDecode
        |> optional "$" (nullable laneAttrDecoder) Nothing
        |> optional "xpdl:Performers" (nullable (list performerDecoder)) Nothing


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
