port module XPDL exposing (XPDL, Msg(ReadXPDL), update, subscriptions)

import Json.Decode exposing (Decoder, decodeString, (:=))
import Json.Decode.Pipeline exposing (decode, hardcoded, required)
import XPDL.Package exposing (Package, packageDecoder)


type alias XPDL =
    Result String Package


type alias Filename =
    String


type alias ReadResult =
    { error : Maybe String
    , result : Maybe String
    }


type Msg
    = ReadXPDL Filename
    | LoadXPDL XPDL


port readXPDL : Filename -> Cmd msg


port jsonXPDL : (ReadResult -> msg) -> Sub msg


defaultXPDLError : String
defaultXPDLError =
    "Error reading XPDL!"


decodeXPDL : String -> XPDL
decodeXPDL json =
    let
        decoder : Decoder Package
        decoder =
            "xpdl:Package" := packageDecoder json
    in
        decodeString decoder json


decodeReadResult : ReadResult -> Msg
decodeReadResult readRes =
    let
        portRes =
            if readRes.error /= Nothing then
                Err (Maybe.withDefault defaultXPDLError readRes.error)
            else if readRes.result /= Nothing then
                Ok (Maybe.withDefault "" readRes.result)
            else
                Err defaultXPDLError

        loadedXPDL =
            portRes `Result.andThen` decodeXPDL
    in
        LoadXPDL loadedXPDL


update : Msg -> XPDL -> ( XPDL, Cmd a )
update msg xpdl =
    case msg of
        ReadXPDL fn ->
            ( xpdl, readXPDL fn )

        LoadXPDL xpdl ->
            ( xpdl, Cmd.none )


subscriptions : XPDL -> Sub Msg
subscriptions _ =
    jsonXPDL decodeReadResult
