module XPDL.Pool exposing (Pools, Pool, poolsDecoder)

import Json.Decode exposing (Decoder, list, string, (:=))
import Json.Decode.Pipeline exposing (decode, nullable, optional, required)
import Dict exposing (Dict, empty, fromList)
import XPDL.Process exposing (ProcessId)
import XPDL.Lane exposing (Lanes, lanesDecoder)


type alias PoolId =
    String


type alias Pools =
    Dict PoolId Pool


type alias Pool =
    { id : PoolId
    , name : String
    , process : ProcessId
    , lanes : Lanes
    }


type alias PoolAttributes =
    { id : PoolId
    , name : Maybe String
    , process : Maybe ProcessId
    }


makePoolFromDecode : Maybe PoolAttributes -> Maybe (List Lanes) -> Pool
makePoolFromDecode attrs maybeLanes =
    let
        id =
            Maybe.withDefault "" (attrs `Maybe.andThen` (Just << .id))

        name =
            Maybe.withDefault "" (attrs `Maybe.andThen` .name)

        procid =
            Maybe.withDefault "" (attrs `Maybe.andThen` .process)

        lanes =
            Maybe.withDefault empty (maybeLanes `Maybe.andThen` List.head)
    in
        Pool id name procid lanes


poolAttributesDecoder : Decoder PoolAttributes
poolAttributesDecoder =
    decode PoolAttributes
        |> required "Id" string
        |> optional "Name" (nullable string) Nothing
        |> optional "Process" (nullable string) Nothing


poolDecoder : Decoder Pool
poolDecoder =
    decode makePoolFromDecode
        |> optional "$" (nullable poolAttributesDecoder) Nothing
        |> optional "xpdl:Lanes" (nullable (list lanesDecoder)) Nothing


poolsDecoder : Decoder Pools
poolsDecoder =
    let
        pools : Maybe (List Pool) -> List Pool
        pools maybePools =
            Maybe.withDefault [] maybePools

        makePoolsDict : List Pool -> List ( PoolId, Pool )
        makePoolsDict pools =
            List.map (\p -> ( p.id, p )) pools

        makePoolsFromDecode : Maybe (List Pool) -> Pools
        makePoolsFromDecode =
            fromList << makePoolsDict << pools
    in
        decode makePoolsFromDecode
            |> optional "xpdl:Pool" (nullable (list poolDecoder)) Nothing
