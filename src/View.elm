module View exposing (view)

import Html exposing (..)
import State exposing (Model, Msg)
import History exposing (History)
import Visualizer.View exposing (visualizer)
import Header.View exposing (header, headerClasses)
import Navigator.View exposing (navigator)
import Toolbox.View exposing (toolbox)
import Styles.Grid exposing (Class(..), withGridNamespace)


view : History Model -> Html State.Msg
view history =
    let
        present =
            history.present
    in
        div [ withGridNamespace.class [ ViewSize, Columns, VerticalColumns ] ]
            [ Html.header [ headerClasses ] (Header.View.header history)
            , div [ withGridNamespace.class [ Columns, Column ] ]
                [ toolbox present
                , navigator present
                , visualizer present
                ]
            ]
