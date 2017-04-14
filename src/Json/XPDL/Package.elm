module Json.XPDL.Package exposing (Package, packageDecoder)

import Json.Decode exposing (..)
import Json.Decode.Maybe exposing (maybeWithDefault)
import Json.Decode.XML exposing (listOfOne)
import Json.XPDL.Pool exposing (Pools, poolsDecoder)
import Json.XPDL.Process exposing (Processes, processesDecoder)


type alias Package =
    { name : String
    , id : String
    , pools : Pools
    , processes : Processes
    }


type alias PackageAttributes =
    { name : String
    , id : String
    }


packageAttributesDecoder : Decoder PackageAttributes
packageAttributesDecoder =
    map2 PackageAttributes
        (maybeWithDefault "" (field "Name" string))
        (field "Id" string)


makePackageFromDecode :
    PackageAttributes
    -> Pools
    -> Processes
    -> Package
makePackageFromDecode { name, id } =
    Package name id


packageDecoder : Decoder Package
packageDecoder =
    map3 makePackageFromDecode
        (field "$" packageAttributesDecoder)
        (field "xpdl:Pools" (listOfOne poolsDecoder))
        (field "xpdl:WorkflowProcesses" (listOfOne processesDecoder))
