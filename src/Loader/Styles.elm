module Loader.Styles exposing (Class(..), css, namespaceId, keyframes, loaderSize)

import Styles.Namespace exposing (Namespace(Loader))
import Css exposing (..)
import Css.Elements exposing (svg, circle)
import Css.Namespace exposing (namespace)


type Class
    = Loader


namespaceId : Namespace
namespaceId =
    Styles.Namespace.Loader


loaderSize : number
loaderSize =
    100


css : Stylesheet
css =
    (stylesheet << namespace namespaceId)
        [ class Loader
            [ position relative
            , height (px loaderSize)
            , width (px loaderSize)
            , descendants
                [ svg
                    [ position absolute
                    , top zero
                    , left zero
                    , margin auto
                    , bottom zero
                    , right zero
                    , height (pct 100)
                    , width (pct 100)
                    , property "animation" "rotate 2s linear infinite"
                    , property "transform-origin" "center center"
                    ]
                , Css.Elements.circle
                    [ property "stroke-dasharray" "1, 200"
                    , property "stroke-dashoffset" "0"
                    , property "stroke-linecap" "round"
                    , property "animation" "dash 1.5s ease-in-out infinite"
                    ]
                ]
            ]
        ]


keyframes : String
keyframes =
    """
    @keyframes rotate {
      100% {
        transform: rotate(360deg);
      }
    }

    @keyframes dash {
      0% {
        stroke-dasharray: 1, 200;
        stroke-dashoffset: 0;
      }
      50% {
        stroke-dasharray: 89, 200;
        stroke-dashoffset: -35px;
      }
      100% {
        stroke-dasharray: 89, 200;
        stroke-dashoffset: -124px;
      }
    }
    """
