module Json.XPDL.Package exposing (Package, packageDecoder)

import Json.Decode exposing (Decoder, string, list, nullable)
import Json.Decode.Pipeline exposing (decode, hardcoded, optional, required)
import Json.Decode.XML exposing (listOfOne)
import Json.XPDL.Pool exposing (Pools, poolsDecoder)
import Json.XPDL.Process exposing (Processes, processesDecoder)


type alias Package =
    { name : String
    , id : String
    , pools : Pools
    , processes : Processes
    , fullRepr : String
    }


type alias PackageAttributes =
    { name : Maybe String
    , id : String
    }


packageAttributesDecoder : Decoder PackageAttributes
packageAttributesDecoder =
    decode PackageAttributes
        |> optional "Name" (nullable string) Nothing
        |> required "Id" string


makePackageFromDecode :
    PackageAttributes
    -> Pools
    -> Processes
    -> String
    -> Package
makePackageFromDecode attrs =
    let
        name =
            Maybe.withDefault "" attrs.name
    in
        Package name attrs.id


packageDecoder : String -> Decoder Package
packageDecoder json =
    decode makePackageFromDecode
        |> required "$" packageAttributesDecoder
        |> required "xpdl:Pools" (listOfOne poolsDecoder)
        |> required "xpdl:WorkflowProcesses" (listOfOne processesDecoder)
        |> hardcoded json
