module Navigator.Styles exposing (Class(..), css)

import Css exposing (..)
import Css.Elements exposing (..)
import Css.Namespace exposing (namespace)
import Styles.Namespace exposing (Namespace(Navigator))
import Styles.Constants exposing (..)


type Class
    = Navigator
    | CurrentProcess


css : Stylesheet
css =
    (stylesheet << namespace Styles.Namespace.Navigator)
        [ (.) Navigator
            [ width (px leftHandTotalWidth)
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
