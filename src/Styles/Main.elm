module Styles.Main exposing (css)

import Css exposing (..)
import Css.Elements exposing (..)
import Styles.Constants exposing (..)


css : Stylesheet
css =
    stylesheet
        [ each
            [ everything, body, html ]
            [ defaultFont, defaultFontSize, boxSizing borderBox ]
        , body
            [ backgroundColor defaultBackground
            , color defaultForeground
            ]
        , each
            [ selector ":not(input):not(textarea)"
            , selector ":not(input):not(textarea)::after"
            , selector ":not(input):not(textarea)::before"
            ]
            [ property "-webkit-user-select" "none"
            , property "user-select" "none"
            , cursor default
            ]
        ]
