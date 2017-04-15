module Json.Decode.Xpdl.Pool exposing (Pools, Pool, poolsDecoder)

import Json.Decode exposing (..)
import Json.Decode.Maybe exposing (maybeWithDefault)
import Json.Decode.Xml exposing (listOfOne)
import Json.Decode.Xpdl.Lane exposing (Lanes, lanesDecoder)
import Json.Decode.Xpdl.Process exposing (ProcessId)


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
    , name : String
    , process : ProcessId
    }


makePoolFromDecode : PoolAttributes -> Lanes -> Pool
makePoolFromDecode { id, name, process } =
    Pool id name process


poolAttributesDecoder : Decoder PoolAttributes
poolAttributesDecoder =
    map3 PoolAttributes
        (field "Id" string)
        (maybeWithDefault "" (field "Name" string))
        (maybeWithDefault "" (field "Process" string))


poolDecoder : Decoder Pool
poolDecoder =
    map2 makePoolFromDecode
        (field "$" poolAttributesDecoder)
        (maybeWithDefault [] (field "xpdl:Lanes" (listOfOne lanesDecoder)))


poolsDecoder : Decoder Pools
poolsDecoder =
    maybeWithDefault [] (field "xpdl:Pool" (list poolDecoder))
