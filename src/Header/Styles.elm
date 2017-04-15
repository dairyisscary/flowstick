module Header.Styles exposing (Class(..), css, namespaceId)

import Css exposing (..)
import Css.Elements exposing (h1, li, ul)
import Css.Namespace exposing (namespace)
import Styles.Icons exposing (smallIconWidth)
import Styles.Grid exposing (columnsMixin, columnMixin)
import Styles.Constants exposing (..)
import Styles.Namespace exposing (Namespace(Header))


type Class
    = Header
    | TitleAndControls
    | SearchBar
    | DisabledButton


namespaceId : Namespace
namespaceId =
    Styles.Namespace.Header


headerHeight : number
headerHeight =
    60


css : Stylesheet
css =
    (stylesheet << namespace namespaceId)
        [ class Header
            [ height (px headerHeight)
            , backgroundColor highlightBackground
            , columnsMixin
            ]
        , class TitleAndControls
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
                , ul
                    [ displayFlex
                    ]
                , li
                    [ marginLeft (px 20)
                    , width (px smallIconWidth)
                    , overflow hidden
                    , children
                        [ selector "i"
                            [ cursor pointer ]
                        ]
                    , withClass DisabledButton
                        [ disabledOpacity
                        , children
                            [ selector "i"
                                [ cursor default ]
                            ]
                        ]
                    ]
                ]
            ]
        , class SearchBar
            [ columnMixin
            ]
        ]
