module Toolbox.View exposing (toolbox)

import Html exposing (..)
import State exposing (Msg, Model)
import Toolbox.Styles exposing (Class(..))
import Html.CssHelpers exposing (withNamespace)
import Styles.Namespace exposing (Namespace(Toolbox), FlowstickNamespace)
import Styles.Icons exposing (IconSize(Normal), icon)


ns : FlowstickNamespace Class id msg
ns =
    withNamespace Styles.Namespace.Toolbox


toolbox : Model -> Html State.Msg
toolbox model =
    ul [ ns.class [ Toolbox.Styles.Toolbox ] ]
        [ li [] [ icon "add box" Normal ] ]
