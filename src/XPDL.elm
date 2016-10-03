port module XPDL exposing (XPDL, Msg(ReadXPDL), update, subscriptions, XPDLState)


type alias XPDLState =
    String


type alias XPDL =
    Result String XPDLState


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


decode : XPDLState -> XPDL
decode x =
    Ok x


decodeXPDL : ReadResult -> Msg
decodeXPDL readRes =
    let
        portRes =
            if readRes.error /= Nothing then
                Err (Maybe.withDefault defaultXPDLError readRes.error)
            else if readRes.result /= Nothing then
                Ok (Maybe.withDefault "" readRes.result)
            else
                Err defaultXPDLError
    in
        LoadXPDL (portRes `Result.andThen` decode)


update : Msg -> XPDL -> ( XPDL, Cmd a )
update msg xpdl =
    case msg of
        ReadXPDL fn ->
            ( xpdl, readXPDL fn )

        LoadXPDL xpdl ->
            ( xpdl, Cmd.none )


subscriptions : XPDL -> Sub Msg
subscriptions _ =
    jsonXPDL decodeXPDL
