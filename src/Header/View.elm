module Header.View exposing (header, headerClasses)

import Html exposing (..)
import Html.Events exposing (onClick)
import Html.CssHelpers exposing (withNamespace)
import XPDL exposing (Msg(..))
import XPDL.File exposing (Msg(..))
import State exposing (Model, Msg)
import Header.Styles exposing (Class(..), namespaceId)
import Styles.Namespace exposing (FlowstickNamespace)


ns : FlowstickNamespace Header.Styles.Class id State.Msg
ns =
    withNamespace namespaceId


headerClasses : Attribute State.Msg
headerClasses =
    ns.class [ Header ]


buttons : Model -> Html State.Msg
buttons model =
    ul []
        [ li [ onClick (State.XPDLMsg (FileMsg OpenFileDialog)) ] [ text "Open" ] ]


titleAndControls : Model -> Html State.Msg
titleAndControls model =
    div [ ns.class [ TitleAndControls ] ]
        [ h1 [] [ text "Flowstick" ]
        , buttons model
        ]


searchBar : Model -> Html State.Msg
searchBar model =
    div [ ns.class [ SearchBar ] ] [ text "" ]


header : Model -> List (Html State.Msg)
header model =
    [ titleAndControls model
    , searchBar model
    ]