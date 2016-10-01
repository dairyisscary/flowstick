port module Stylesheets exposing (..)

import Css exposing (Stylesheet)
import Css.File exposing (..)
import Html exposing (div)
import Html.App as Html
import Styles.Main


port files : CssFileStructure -> Cmd msg


allStyleSheets : List Stylesheet
allStyleSheets =
    [ Styles.Main.css ]


cssFiles : CssFileStructure
cssFiles =
    toFileStructure [ ( "elm-css-build.css", compile allStyleSheets ) ]


main : Program Never
main =
    Html.program
        { init = ( (), files cssFiles )
        , view = \_ -> (div [] [])
        , update = \_ _ -> ( (), Cmd.none )
        , subscriptions = \_ -> Sub.none
        }
