module Styles.Grid
    exposing
        ( Class(..)
        , css
        , withGridNamespace
        , columnsMixin
        , columnMixin
        , vertColumnsMixin
        )

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


columnsMixin : Mixin
columnsMixin =
    displayFlex


vertColumnsMixin : Mixin
vertColumnsMixin =
    mixin [ displayFlex, flexDirection column ]


columnMixin : Mixin
columnMixin =
    flex (int 1)


css : Stylesheet
css =
    (stylesheet << namespace Grid)
        [ class Columns
            [ columnsMixin ]
        , class VerticalColumns
            [ withClass Columns
                [ flexDirection column ]
            ]
        , class Column
            [ columnMixin ]
        , class FullSize
            [ width (pct 100)
            , height (pct 100)
            ]
        , class ViewSize
            [ width (vw 100)
            , height (vh 100)
            ]
        ]
