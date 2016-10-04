module XPDL.Package exposing (Package, packageDecoder)

import Json.Decode exposing (Decoder, string)
import Json.Decode.Pipeline exposing (decode, hardcoded, nullable, optional)


type alias Package =
    { name : String
    , id : String
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


makePackageFromDecode : Maybe PackageAttributes -> String -> Package
makePackageFromDecode attrs =
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
    in
        Package name id


packageDecoder : String -> Decoder Package
packageDecoder json =
    decode makePackageFromDecode
        |> optional "$" (nullable packageAttributesDecoder) Nothing
        |> hardcoded json
