module Visualizer.Styles
    exposing
        ( Class(..)
        , css
        , namespaceId
        , activityHeight
        , activityWidth
        , leftOffset
        , topOffset
        , transitionThickness
        )

import Css exposing (..)
import Css.Elements exposing (..)
import Css.Namespace exposing (..)
import Styles.Constants exposing (..)
import Styles.Grid exposing (columnMixin)
import Styles.Namespace exposing (Namespace(Visualizer))
import Loader.Styles exposing (loaderSize)


type Class
    = Visualizer
    | Transitions
    | Lanes
    | LaneBuffer
    | SystemLane
    | Activities
    | ProcessTitle
    | Loader
    | Selected


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


transitionThickness : number
transitionThickness =
    2


semiBoxForegroundOne : Color
semiBoxForegroundOne =
    rgba boxForegroundOne.red boxForegroundOne.green boxForegroundOne.blue 0.5


css : Stylesheet
css =
    (stylesheet << namespace namespaceId)
        [ class Visualizer
            [ overflow auto
            , position relative
            , columnMixin
            ]
        , class Loader
            [ position absolute
            , top (pct 50)
            , left (pct 50)
            , marginTop (px <| loaderSize / -2)
            , marginLeft (px <| loaderSize / -2)
            , width (px loaderSize)
            , height (px loaderSize)
            , color (rgb 0 100 0)
            , property "stroke" highlightBackground.value
            ]
        , class ProcessTitle
            [ position absolute
            , top (px defaultPadding)
            , fontSize (px 35)
            , left (px leftOffset)
            ]
        , class SystemLane
            [ fontStyle italic ]
        , class Lanes
            [ children
                [ div
                    [ backgroundColor offBackground
                    , border3 (px 1) solid defaultSeparator
                    , position absolute
                    , left (px leftOffset)
                    , property "z-index" "2"
                    ]
                ]
            ]
        , class LaneBuffer
            [ position absolute
            , property "content" "''"
            , display block
            , top zero
            , left zero
            , property "z-index" "1"
            ]
        , class Transitions
            [ children
                [ div
                    [ height (px transitionThickness)
                    , backgroundColor highlightBackground
                    , position absolute
                    , property "z-index" "3"
                    ]
                ]
            ]
        , class Activities
            [ children
                [ div
                    [ height (px activityHeight)
                    , width (px activityWidth)
                    , position absolute
                    , color boxForegroundOne
                    , cursor pointer
                    , backgroundColor semiBoxForegroundOne
                    , borderRadius (px defaultBorderRadius)
                    , textOverflow ellipsis
                    , overflow hidden
                    , property "z-index" "3"
                    , padding (px 10)
                    , property "transition" "color 0.1s ease-in-out, background-color 0.1s ease-in-out"
                    , withClass Selected
                        [ color (rgb 255 255 255)
                        , backgroundColor boxForegroundOne
                        , property "z-index" "4"
                        ]
                    ]
                ]
            ]
        ]
