module XPDL exposing (XPDL, Msg, initialXPDL, update, subscriptions, readFile)

import XPDL.Process exposing (Processes)
import Json.XPDL as JX


type alias XPDLState =
    { processes : Processes
    }


type XPDL
    = NotLoaded
    | Loaded XPDLState
    | ErrorLoad String


type Msg
    = JSONMsg (JX.Msg)


readFile : String -> Msg
readFile =
    JSONMsg << JX.ReadXPDL


initialXPDL : XPDL
initialXPDL =
    NotLoaded


convertJsonToState : JX.XPDL -> XPDL
convertJsonToState jxpdl =
    case jxpdl of
        Ok package ->
            -- TODO
            ErrorLoad package.fullRepr

        Err str ->
            ErrorLoad str


jsonUpdate : JX.Msg -> XPDL -> ( XPDL, Cmd a )
jsonUpdate msg model =
    let
        ( jsonXpdl, jsonCmd ) =
            JX.handleMessage msg

        newXpdl =
            Maybe.withDefault model (jsonXpdl `Maybe.andThen` (Just << convertJsonToState))
    in
        ( newXpdl, jsonCmd )


update : Msg -> XPDL -> ( XPDL, Cmd a )
update msg model =
    case msg of
        JSONMsg jmsg ->
            jsonUpdate jmsg model


subscriptions : XPDL -> Sub Msg
subscriptions _ =
    Sub.map JSONMsg JX.subscriptions
