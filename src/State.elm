module State exposing (Model, Msg(..), init, update, subscriptions)

import XPDL as X
import Drag


type Msg
    = XPDLMsg X.Msg
    | DragMsg Drag.Msg


type alias Model =
    { xpdl : X.XPDL
    , drag : Drag.DragInfo
    }


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
    case msg of
        XPDLMsg xmsg ->
            let
                ( newXpdl, xpdlCmd ) =
                    X.update xmsg model.xpdl
            in
                ( { model | xpdl = newXpdl }, xpdlCmd )

        DragMsg dmsg ->
            let
                ( newDrag, dragCmd ) =
                    Drag.update dmsg model.drag
            in
                ( { model | drag = newDrag }, dragCmd )


subscriptions : Model -> Sub Msg
subscriptions model =
    Sub.batch
        [ Sub.map XPDLMsg (X.subscriptions model.xpdl)
        , Sub.map DragMsg (Drag.subscriptions model.drag)
        ]
