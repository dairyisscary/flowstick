module Styles.Main exposing (css)

import Css exposing (..)
import Css.Elements exposing (..)


css : Stylesheet
css =
    stylesheet
        [ body
            [ backgroundColor (rgb 20 20 20)
            , color (rgb 230 230 230)
            ]
        ]
