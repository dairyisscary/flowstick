module Visualizer.Styles exposing (Class(..), css, namespaceId)

import Css exposing (..)
import Css.Elements exposing (..)
import Css.Namespace exposing (..)
import Styles.Namespace exposing (Namespace(Visualizer))


type Class
    = Visualizer
    | Lanes
    | SystemLane


namespaceId : Namespace
namespaceId =
    Styles.Namespace.Visualizer


css : Stylesheet
css =
    (stylesheet << namespace namespaceId)
        [ (.) SystemLane
            [ fontStyle italic ]
        , (.) Lanes
            [ children
                [ div [ height (px 200) ] ]
            ]
        ]
