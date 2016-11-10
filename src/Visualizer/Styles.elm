module Visualizer.Styles
    exposing
        ( Class(..)
        , css
        , namespaceId
        , activityHeight
        , activityWidth
        , leftOffset
        , topOffset
        )

import Css exposing (..)
import Css.Elements exposing (..)
import Css.Namespace exposing (..)
import Styles.Constants exposing (..)
import Styles.Grid exposing (columnMixin)
import Styles.Namespace exposing (Namespace(Visualizer))


type Class
    = Visualizer
    | Lanes
    | SystemLane
    | Activities
    | ProcessTitle


namespaceId : Namespace
namespaceId =
    Styles.Namespace.Visualizer


activityHeight : number
activityHeight =
    60


activityWidth : number
activityWidth =
    90


leftOffset : number
leftOffset =
    50


topOffset : number
topOffset =
    95


css : Stylesheet
css =
    (stylesheet << namespace namespaceId)
        [ (.) Visualizer
            [ overflow auto
            , position relative
            , columnMixin
            ]
        , (.) ProcessTitle
            [ position absolute
            , top (px defaultPadding)
            , fontSize (px 35)
            , left (px leftOffset)
            ]
        , (.) SystemLane
            [ fontStyle italic ]
        , (.) Lanes
            [ children
                [ div
                    [ backgroundColor offBackground
                    , border3 (px 1) solid defaultSeparator
                    , position absolute
                    , left (px leftOffset)
                    ]
                ]
            ]
        , (.) Activities
            [ children
                [ div
                    [ height (px activityHeight)
                    , width (px activityWidth)
                    , position absolute
                    , backgroundColor boxForegroundOne
                    , borderRadius (px defaultBorderRadius)
                    , textOverflow ellipsis
                    , overflow hidden
                    , padding (px 10)
                    ]
                ]
            ]
        ]
