module Styles.Grid exposing (Class(..), css, withGridNamespace)

import Css exposing (..)
import Css.Namespace exposing (namespace)
import Styles.Namespace exposing (FlowstickNamespace, Namespace(Grid))
import Html.CssHelpers exposing (withNamespace)


type Class
    = Columns
    | Column
    | VerticalColumns
    | FullSize
    | ViewSize


withGridNamespace : FlowstickNamespace Class id msg
withGridNamespace =
    withNamespace Grid


css : Stylesheet
css =
    (stylesheet << namespace Grid)
        [ (.) Columns
            [ displayFlex ]
        , (.) VerticalColumns
            [ withClass Columns
                [ flexDirection column ]
            ]
        , (.) Column
            [ flex (int 1) ]
        , (.) FullSize
            [ width (pct 100)
            , height (pct 100)
            ]
        , (.) ViewSize
            [ width (vw 100)
            , height (vh 100)
            ]
        ]
