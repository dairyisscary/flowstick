port module XPDL exposing (XPDL, Msg(ReadXPDL), update, subscriptions)


type alias XPDL =
    String


type alias Filename =
    String


type alias ReadResult =
    { error : Maybe String
    , result : Maybe String
    }


type Msg
    = ReadXPDL Filename
    | DecodeXPDL ReadResult


port readXPDL : Filename -> Cmd msg


port jsonXPDL : (ReadResult -> msg) -> Sub msg


update : Msg -> XPDL -> ( XPDL, Cmd a )
update msg xpdl =
    case msg of
        ReadXPDL fn ->
            ( xpdl, readXPDL fn )

        DecodeXPDL read ->
            ( Maybe.withDefault "bad read" read.result, Cmd.none )


subscriptions : XPDL -> Sub Msg
subscriptions _ =
    jsonXPDL DecodeXPDL
