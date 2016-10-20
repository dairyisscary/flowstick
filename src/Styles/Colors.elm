module Styles.Colors exposing (..)

import Css exposing (..)


defaultBackground : Color
defaultBackground =
    rgb 33 47 65


defaultForeground : Color
defaultForeground =
    rgb 255 255 255


defaultFont : Mixin
defaultFont =
    fontFamilies [ "Heebo", .value sansSerif ]


defaultFontSize : Mixin
defaultFontSize =
    fontSize (px 16)
