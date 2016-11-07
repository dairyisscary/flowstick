module XPDL exposing (XPDL(..), XPDLState, Msg(..), initialXPDL, update, subscriptions)

import XPDL.File as File
import XPDL.Lane exposing (Lanes, lanesFromJson)
import XPDL.Process exposing (Processes, ProcessId, processesFromJson)
import XPDL.Activity exposing (Activities, activitiesFromJson)
import Json.XPDL as JX


type alias XPDLState =
    { processes : Processes
    , entries : List ProcessId
    , lanes : Lanes
    , activities : Activities
    , currentProcess : Maybe ProcessId
    }


type XPDL
    = NotLoaded
    | Loaded XPDLState
    | ErrorLoad String


type Msg
    = JSONMsg JX.Msg
    | FileMsg File.Msg
    | ChangeCurrentProcess ProcessId


initialXPDL : XPDL
initialXPDL =
    NotLoaded


convertJsonToState : JX.XPDL -> XPDL
convertJsonToState jxpdl =
    case jxpdl of
        Ok package ->
            Loaded
                { processes = processesFromJson package
                , entries = List.map (.id) package.processes
                , lanes = lanesFromJson package
                , currentProcess = Nothing
                , activities = activitiesFromJson package
                }

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

        FileMsg fmsg ->
            ( model, File.handleMessage fmsg )

        ChangeCurrentProcess newProcId ->
            case model of
                Loaded state ->
                    ( Loaded { state | currentProcess = Just newProcId }, Cmd.none )

                _ ->
                    ( model, Cmd.none )


subscriptions : XPDL -> Sub Msg
subscriptions _ =
    Sub.batch
        [ Sub.map JSONMsg JX.subscriptions
        , Sub.map JSONMsg File.subscriptions
        ]
