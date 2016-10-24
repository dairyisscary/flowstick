module State exposing (Model, Msg(..), init, update, subscriptions)

import XPDL as X


type Msg
    = XPDLMsg X.Msg


type alias Model =
    { xpdl : X.XPDL
    }


initialModel : Model
initialModel =
    { xpdl = X.initialXPDL
    }


init : ( Model, Cmd Msg )
init =
    ( initialModel, Cmd.none )


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    case msg of
        XPDLMsg xmsg ->
            let
                ( newXpdl, xpdlCmd ) =
                    X.update xmsg model.xpdl
            in
                ( { model | xpdl = newXpdl }, xpdlCmd )


subscriptions : Model -> Sub Msg
subscriptions model =
    Sub.batch
        [ Sub.map XPDLMsg (X.subscriptions model.xpdl) ]
