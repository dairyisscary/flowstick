module Update exposing (init, update, subscriptions)

import History exposing (History, compose, initializeHistory)
import State exposing (Msg(..), Model)
import XPDL as X
import Drag


initialModel : Model
initialModel =
    { xpdl = X.initialXPDL
    , drag = Drag.init
    }


initialHistoryModel : History Model
initialHistoryModel =
    initializeHistory initialModel


init : ( History Model, Cmd Msg )
init =
    ( initialHistoryModel, Cmd.none )


presentUpdate : Msg -> Model -> ( Model, Cmd Msg )
presentUpdate msg model =
    let
        ( newXpdl, xpdlCmd ) =
            X.update msg model

        ( newDrag, dragCmd ) =
            Drag.update msg model.drag
    in
        ( { model | xpdl = newXpdl, drag = newDrag }
        , Cmd.batch [ xpdlCmd, dragCmd ]
        )


includeHistoryMessage : Msg -> Bool
includeHistoryMessage msg =
    case msg of
        Move _ ->
            False

        SelectActivity _ _ ->
            False

        _ ->
            True


includeMessage : Msg -> Bool
includeMessage msg =
    case msg of
        StopDragging ->
            True

        _ ->
            False


update : Msg -> History Model -> ( History Model, Cmd Msg )
update =
    compose includeHistoryMessage includeMessage presentUpdate


presentSubscriptions : Model -> Sub Msg
presentSubscriptions model =
    Sub.batch
        [ X.subscriptions model.xpdl
        , Drag.subscriptions model.drag
        ]


subscriptions : History Model -> Sub Msg
subscriptions history =
    presentSubscriptions history.present
