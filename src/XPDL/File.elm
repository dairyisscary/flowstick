port module XPDL.File exposing (Model, Msg(..), handleMessage, subscriptions)

import Json.XPDL as JX


type Msg
    = OpenFileDialog


type alias Model =
    { filename : Maybe String
    }


port openFileDialog : () -> Cmd msg


port recieveFilenameFromDialog : (String -> msg) -> Sub msg


handleMessage : Msg -> Cmd msg
handleMessage msg =
    case msg of
        OpenFileDialog ->
            openFileDialog ()


subscriptions : Sub JX.Msg
subscriptions =
    recieveFilenameFromDialog JX.ReadXPDL
