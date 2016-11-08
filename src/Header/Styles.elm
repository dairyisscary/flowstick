module Header.Styles exposing (Class(..), css, namespaceId)

import Css exposing (..)
import Css.Elements exposing (h1, li)
import Css.Namespace exposing (namespace)
import Styles.Grid exposing (columnsMixin, columnMixin)
import Styles.Constants exposing (..)
import Styles.Namespace exposing (Namespace(Header))


type Class
    = Header
    | TitleAndControls
    | SearchBar


namespaceId : Namespace
namespaceId =
    Styles.Namespace.Header


headerHeight : number
headerHeight =
    60


css : Stylesheet
css =
    (stylesheet << namespace namespaceId)
        [ (.) Header
            [ height (px headerHeight)
            , backgroundColor highlightBackground
            , columnsMixin
            ]
        , (.) TitleAndControls
            [ columnsMixin
            , alignItems center
            , width (px leftHandTotalWidth)
            , borderRight3 (px 1) solid highlightSeperator
            , descendants
                [ h1
                    [ offFont
                    , fontWeight bold
                    , paddingLeft (px 20)
                    , fontSize (px 20)
                    ]
                , li
                    [ marginLeft (px 20)
                    ]
                ]
            ]
        , (.) SearchBar
            [ columnMixin
            ]
        ]
