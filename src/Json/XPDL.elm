port module Json.XPDL exposing (XPDL, Msg(ReadXPDL), handleMessage, subscriptions)

import Json.Decode exposing (Decoder, decodeString, (:=))
import Json.XPDL.Package exposing (Package, packageDecoder)


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


handleMessage : Msg -> ( Maybe XPDL, Cmd a )
handleMessage msg =
    case msg of
        ReadXPDL fn ->
            ( Nothing, readXPDL fn )

        LoadXPDL xpdl ->
            ( Just xpdl, Cmd.none )


subscriptions : Sub Msg
subscriptions =
    jsonXPDL decodeReadResult
