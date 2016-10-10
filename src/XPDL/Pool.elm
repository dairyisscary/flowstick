module XPDL.Pool exposing (Pools, Pool, poolsDecoder)

import Json.Decode exposing (Decoder, list, string, (:=))
import Json.Decode.Pipeline exposing (decode, nullable, optional, required)
import Json.Decode.XML exposing (listOfOne)
import XPDL.Process exposing (ProcessId)
import XPDL.Lane exposing (Lanes, lanesDecoder)


type alias PoolId =
    String


type alias Pools =
    List Pool


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


makePoolFromDecode : PoolAttributes -> Lanes -> Pool
makePoolFromDecode attrs =
    let
        name =
            Maybe.withDefault "" attrs.name

        procid =
            Maybe.withDefault "" attrs.process
    in
        Pool attrs.id name procid


poolAttributesDecoder : Decoder PoolAttributes
poolAttributesDecoder =
    decode PoolAttributes
        |> required "Id" string
        |> optional "Name" (nullable string) Nothing
        |> optional "Process" (nullable string) Nothing


poolDecoder : Decoder Pool
poolDecoder =
    decode makePoolFromDecode
        |> required "$" poolAttributesDecoder
        |> optional "xpdl:Lanes" (listOfOne lanesDecoder) []


poolsDecoder : Decoder Pools
poolsDecoder =
    decode identity
        |> optional "xpdl:Pool" (list poolDecoder) []
