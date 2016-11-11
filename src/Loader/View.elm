module Loader.View exposing (loader)

import Svg exposing (circle, svg)
import Svg.Attributes exposing (r, cx, cy, fill, stroke, strokeWidth, strokeMiterlimit)
import Html exposing (Html, div)
import Html.CssHelpers exposing (withNamespace)
import Loader.Styles exposing (Class(..), namespaceId)
import Styles.Namespace exposing (FlowstickNamespace)
import Loader.Styles exposing (loaderSize)


ns : FlowstickNamespace Loader.Styles.Class id msg
ns =
    withNamespace namespaceId


radiusSize : String
radiusSize =
    toString <| loaderSize // 5


centerSize : String
centerSize =
    toString <| loaderSize // 2


loader : Html msg
loader =
    div [ ns.class [ Loader ] ]
        [ svg []
            [ circle
                [ r radiusSize
                , cx centerSize
                , cy centerSize
                , fill "none"
                , strokeWidth "3"
                , strokeMiterlimit "10"
                ]
                []
            ]
        ]
