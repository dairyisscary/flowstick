module Visualizer.Styles exposing (Class(..), css, namespaceId)

import Css exposing (..)
import Css.Elements exposing (..)
import Css.Namespace exposing (..)
import Styles.Constants exposing (..)
import Styles.Namespace exposing (Namespace(Visualizer))


type Class
    = Visualizer
    | Lanes
    | SystemLane
    | Activities


namespaceId : Namespace
namespaceId =
    Styles.Namespace.Visualizer


css : Stylesheet
css =
    (stylesheet << namespace namespaceId)
        [ (.) Visualizer
            [ overflow auto
            , position relative
            ]
        , (.) SystemLane
            [ fontStyle italic ]
        , (.) Lanes
            [ children
                [ div
                    [ height (px 200)
                    , backgroundColor offBackground
                    , border3 (px 1) solid defaultSeparator
                    ]
                ]
            ]
        , (.) Activities
            [ children
                [ div
                    [ height (px 50)
                    , width (px 100)
                    , position absolute
                    , backgroundColor boxForegroundOne
                    , borderRadius defaultRadius
                    ]
                ]
            ]
        ]
