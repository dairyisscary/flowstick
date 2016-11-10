module Toolbox.Styles exposing (Class(..), css, toolboxWidth)

import Css exposing (..)
import Css.Elements exposing (li)
import Css.Namespace exposing (namespace)
import Styles.Namespace exposing (Namespace(Toolbox))
import Styles.Constants exposing (..)
import Styles.Grid exposing (vertColumnsMixin)
import Styles.Icons exposing (iconWidth)


type Class
    = Toolbox


toolboxWidth : number
toolboxWidth =
    60


css : Stylesheet
css =
    (stylesheet << namespace Styles.Namespace.Toolbox)
        [ (.) Toolbox
            [ width (px toolboxWidth)
            , backgroundColor darkBackground
            , vertColumnsMixin
            , alignItems center
            , descendants
                [ li
                    [ width (px iconWidth)
                    , marginTop (px 30)
                    ]
                ]
            ]
        ]
