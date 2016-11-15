port module Stylesheets exposing (..)

import Css exposing (Stylesheet)
import Css.File exposing (..)
import Styles.Reset
import Styles.Main
import Styles.Grid
import Styles.Icons
import Visualizer.Styles
import Navigator.Styles
import Header.Styles
import Toolbox.Styles
import Loader.Styles


port files : CssFileStructure -> Cmd msg


allStyleSheets : List Stylesheet
allStyleSheets =
    [ Styles.Reset.css
    , Styles.Main.css
    , Styles.Grid.css
    , Styles.Icons.css
    , Visualizer.Styles.css
    , Navigator.Styles.css
    , Header.Styles.css
    , Toolbox.Styles.css
    , Loader.Styles.css
    ]


cssFiles : CssFileStructure
cssFiles =
    let
        compiledCss =
            compile allStyleSheets

        allCss =
            { compiledCss | css = compiledCss.css ++ Loader.Styles.keyframes }
    in
        toFileStructure [ ( "elm-css-build.css", allCss ) ]


main : CssCompilerProgram
main =
    compiler files cssFiles
