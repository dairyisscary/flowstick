module Styles.Main exposing (css)

import Css exposing (..)
import Css.Elements exposing (..)
import Styles.Constants exposing (..)


css : Stylesheet
css =
    stylesheet
        [ each
            [ everything, body, html ]
            [ defaultFont, defaultFontSize ]
        , body
            [ backgroundColor defaultBackground
            , color defaultForeground
            ]
        ]
