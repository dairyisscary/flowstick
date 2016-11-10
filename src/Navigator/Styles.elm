module Navigator.Styles exposing (Class(..), css)

import Css exposing (..)
import Css.Elements exposing (..)
import Css.Namespace exposing (namespace)
import Styles.Namespace exposing (Namespace(Navigator))
import Styles.Constants exposing (..)
import Toolbox.Styles exposing (toolboxWidth)


type Class
    = Navigator
    | CurrentProcess


css : Stylesheet
css =
    (stylesheet << namespace Styles.Namespace.Navigator)
        [ (.) Navigator
            [ width (px (leftHandTotalWidth - toolboxWidth))
            , padding (px defaultPadding)
            , borderRight3 (px 1) solid brightSeparator
            , descendants
                [ li
                    [ paddingBottom (px 10)
                    , color offForeground
                    , cursor pointer
                    ]
                , (.) CurrentProcess
                    [ color defaultForeground ]
                ]
            ]
        ]
