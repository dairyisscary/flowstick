module Visualizer.Styles exposing (Class(..), css, namespaceId, activityHeight, activityWidth)

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


namespaceId : Namespace
namespaceId =
    Styles.Namespace.Visualizer


activityHeight : number
activityHeight =
    60


activityWidth : number
activityWidth =
    90


css : Stylesheet
css =
    (stylesheet << namespace namespaceId)
        [ (.) Visualizer
            [ overflow auto
            , position relative
            , columnMixin
            ]
        , (.) SystemLane
            [ fontStyle italic ]
        , (.) Lanes
            [ children
                [ div
                    [ backgroundColor offBackground
                    , border3 (px 1) solid defaultSeparator
                    , position absolute
                    , left zero
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
                    , borderRadius defaultRadius
                    , textOverflow ellipsis
                    , overflow hidden
                    , padding (px 10)
                    ]
                ]
            ]
        ]
