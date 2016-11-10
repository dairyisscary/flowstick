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


darkBackground : Color
darkBackground =
    rgb 28 41 59


highlightBackground : Color
highlightBackground =
    rgb 0 121 196


highlightSeperator : Color
highlightSeperator =
    rgb 25 134 201


offForeground : Color
offForeground =
    rgb 98 127 152


brightSeparator : Color
brightSeparator =
    rgb 51 75 105


defaultSeparator : Color
defaultSeparator =
    rgb 44 64 90


defaultFont : Mixin
defaultFont =
    fontFamilies [ "Heebo", .value sansSerif ]


offFont : Mixin
offFont =
    fontFamilies [ "Dosis", .value serif ]


defaultFontSize : Mixin
defaultFontSize =
    fontSize (px 16)


boxForegroundOne : Color
boxForegroundOne =
    rgb 38 193 201


leftHandTotalWidth : number
leftHandTotalWidth =
    300


defaultPadding : number
defaultPadding =
    30


defaultBorderRadius : number
defaultBorderRadius =
    7
