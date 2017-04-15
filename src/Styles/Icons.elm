module Styles.Icons
    exposing
        ( IconSize(..)
        , css
        , icon
        , xSmallIconWidth
        , smallIconWidth
        , iconWidth
        , largeIconWidth
        )

import Html exposing (Html, i, text)
import Html.Attributes as HA
import Css exposing (..)
import Css.Namespace exposing (namespace)
import Styles.Namespace exposing (Namespace(Icons))


type IconSize
    = XSmall
    | Small
    | Normal
    | Large


xSmallIconWidth : number
xSmallIconWidth =
    18


smallIconWidth : number
smallIconWidth =
    24


iconWidth : number
iconWidth =
    36


largeIconWidth : number
largeIconWidth =
    48


icon : String -> IconSize -> Html msg
icon iconName size =
    i [ HA.class ("material-icons Icons" ++ toString size) ]
        [ Html.text iconName ]


css : Stylesheet
css =
    (stylesheet << namespace Icons)
        [ class XSmall
            [ fontSize (px xSmallIconWidth)
            ]
        , class Small
            [ fontSize (px smallIconWidth)
            ]
        , class Normal
            [ fontSize (px iconWidth)
            ]
        , class Large
            [ fontSize (px largeIconWidth)
            ]
        ]
