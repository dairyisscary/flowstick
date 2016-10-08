module XPDL.Package exposing (Package, packageDecoder)

import Json.Decode exposing (Decoder, string, list)
import Json.Decode.Pipeline exposing (decode, hardcoded, nullable, optional)
import Dict exposing (Dict, empty)
import XPDL.Pool exposing (Pools, poolsDecoder)
import XPDL.Process exposing (Processes, processesDecoder)


type alias Package =
    { name : String
    , id : String
    , pools : Pools
    , processes : Processes
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
    -> Maybe (List Processes)
    -> String
    -> Package
makePackageFromDecode attrs maybePools maybeActs =
    let
        emptyDefault : Maybe String -> String
        emptyDefault =
            Maybe.withDefault ""

        chain : (PackageAttributes -> Maybe b) -> Maybe b
        chain =
            Maybe.andThen attrs

        defaultedDict : Maybe (List (Dict a b)) -> Dict a b
        defaultedDict =
            Maybe.withDefault empty << List.head << Maybe.withDefault []

        name =
            emptyDefault (chain .name)

        id =
            emptyDefault (chain .id)

        pools =
            defaultedDict maybePools

        procs =
            defaultedDict maybeActs
    in
        Package name id pools procs


packageDecoder : String -> Decoder Package
packageDecoder json =
    decode makePackageFromDecode
        |> optional "$" (nullable packageAttributesDecoder) Nothing
        |> optional "xpdl:Pools" (nullable (list poolsDecoder)) Nothing
        |> optional "xpdl:WorkflowProcesses" (nullable (list processesDecoder)) Nothing
        |> hardcoded ""
