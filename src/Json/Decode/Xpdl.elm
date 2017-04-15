port module Json.Decode.Xpdl
    exposing
        ( XPDLResult
        , Msg(ReadXPDL)
        , handleMessage
        , subscriptions
        )

import Json.Decode exposing (Decoder, Value, decodeValue, field)
import Json.Decode.Xpdl.Package exposing (Package, packageDecoder)


type alias XPDLResult =
    Result String Package


type alias Filename =
    String


type alias ReadResult =
    { error : Maybe String
    , result : Value
    }


type Msg
    = ReadXPDL Filename
    | LoadXPDL XPDLResult


port readXPDL : Filename -> Cmd msg


port jsonXPDL : (ReadResult -> msg) -> Sub msg


decodeXPDL : Value -> XPDLResult
decodeXPDL =
    decodeValue <| field "xpdl:Package" packageDecoder


decodeReadResult : ReadResult -> Msg
decodeReadResult { error, result } =
    let
        portRes =
            if error /= Nothing then
                Err (Maybe.withDefault "Error reading XPDL!" error)
            else
                Ok result
    in
        LoadXPDL <| Result.andThen decodeXPDL portRes


handleMessage : Msg -> ( Maybe XPDLResult, Cmd a )
handleMessage msg =
    case msg of
        ReadXPDL fn ->
            ( Nothing, readXPDL fn )

        LoadXPDL xpdl ->
            ( Just xpdl, Cmd.none )


subscriptions : Sub Msg
subscriptions =
    jsonXPDL decodeReadResult
