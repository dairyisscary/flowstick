module State exposing (Model, Msg, Msg(UpdateFilename), init, update, subscriptions, readFile)

import XPDL as X


type Msg
    = UpdateFilename String
    | XPDLMsg X.Msg


type alias Model =
    { xpdl : X.XPDL
    , filename : String
    }


readFile : String -> Msg
readFile =
    XPDLMsg << X.readFile


initialModel : Model
initialModel =
    { xpdl = X.initialXPDL
    , filename = ""
    }


init : ( Model, Cmd Msg )
init =
    ( initialModel, Cmd.none )


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    case msg of
        UpdateFilename fn ->
            ( { model | filename = fn }, Cmd.none )

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
