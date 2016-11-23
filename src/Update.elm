module Update exposing (init, update, subscriptions)

import State exposing (Msg(..), Model)
import XPDL as X
import Drag


initialModel : Model
initialModel =
    { xpdl = X.initialXPDL
    , drag = Drag.init
    }


init : ( Model, Cmd Msg )
init =
    ( initialModel, Cmd.none )


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    let
        ( newXpdl, xpdlCmd ) =
            X.update msg model

        ( newDrag, dragCmd ) =
            Drag.update msg model.drag
    in
        ( { model | xpdl = newXpdl, drag = newDrag }
        , Cmd.batch [ xpdlCmd, dragCmd ]
        )


subscriptions : Model -> Sub Msg
subscriptions model =
    Sub.batch
        [ X.subscriptions model.xpdl
        , Drag.subscriptions model.drag
        ]
