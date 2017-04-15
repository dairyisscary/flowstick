port module Xpdl.File exposing (Model, Msg(..), handleMessage, subscriptions)

import Json.Decode.Xpdl as JDX


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


subscriptions : Sub JDX.Msg
subscriptions =
    recieveFilenameFromDialog JDX.ReadXPDL
