module Styles.Grid exposing (Class(..), css, withGridNamespace, columnsMixin, columnMixin)

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


columnMixin : Mixin
columnMixin =
    flex (int 1)


css : Stylesheet
css =
    (stylesheet << namespace Grid)
        [ (.) Columns
            [ columnsMixin ]
        , (.) VerticalColumns
            [ withClass Columns
                [ flexDirection column ]
            ]
        , (.) Column
            [ columnMixin ]
        , (.) FullSize
            [ width (pct 100)
            , height (pct 100)
            ]
        , (.) ViewSize
            [ width (vw 100)
            , height (vh 100)
            ]
        ]
