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


offForeground : Color
offForeground =
    rgb 98 127 152


defaultSeparator : Color
defaultSeparator =
    rgb 44 64 90


defaultFont : Mixin
defaultFont =
    fontFamilies [ "Heebo", .value sansSerif ]


defaultFontSize : Mixin
defaultFontSize =
    fontSize (px 16)


boxForegroundOne : Color
boxForegroundOne =
    rgb 38 193 201


defaultRadius =
    px 10
