module XPDL.Package exposing (Package, packageDecoder)

import Json.Decode exposing (Decoder, string, list)
import Json.Decode.Pipeline exposing (decode, hardcoded, nullable, optional)
import Dict exposing (empty)
import XPDL.Pool exposing (Pools, Pool, poolsDecoder)


type alias Package =
    { name : String
    , id : String
    , pools : Pools
    , fullRepr : String
    }


type alias PackageAttributes =
    { name : Maybe String
    , id : Maybe String
    }


packageAttributesDecoder : Decoder PackageAttributes
packageAttributesDecoder =
    decode PackageAttributes
        |> optional "Name" (nullable string) Nothing
        |> optional "Id" (nullable string) Nothing


makePackageFromDecode :
    Maybe PackageAttributes
    -> Maybe (List Pools)
    -> String
    -> Package
makePackageFromDecode attrs maybePools =
    let
        emptyDefault : Maybe String -> String
        emptyDefault =
            Maybe.withDefault ""

        chain : (PackageAttributes -> Maybe b) -> Maybe b
        chain =
            Maybe.andThen attrs

        name =
            emptyDefault (chain .name)

        id =
            emptyDefault (chain .id)

        firstPools =
            List.head (Debug.log "test" (Maybe.withDefault [] maybePools))

        pools =
            Maybe.withDefault empty firstPools
    in
        Package name id pools


packageDecoder : String -> Decoder Package
packageDecoder json =
    decode makePackageFromDecode
        |> optional "$" (nullable packageAttributesDecoder) Nothing
        |> optional "xpdl:Pools" (nullable (list poolsDecoder)) Nothing
        |> hardcoded json
