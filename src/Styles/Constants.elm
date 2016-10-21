module Styles.Constants exposing (..)

import Css exposing (..)


defaultBackground : Color
defaultBackground =
    rgb 33 47 65


defaultForeground : Color
defaultForeground =
    rgb 255 255 255


offBackground : Color
offBackground =
    rgb 34 51 71


defaultSeparator : Color
defaultSeparator =
    rgb 44 64 90


defaultFont : Mixin
defaultFont =
    fontFamilies [ "Heebo", .value sansSerif ]


defaultFontSize : Mixin
defaultFontSize =
    fontSize (px 16)
