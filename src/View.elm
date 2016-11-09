module View exposing (view)

import Html exposing (..)
import State exposing (Model, Msg)
import Visualizer.View exposing (visualizer)
import Header.View exposing (header, headerClasses)
import Navigator.View exposing (navigator)
import Toolbox.View exposing (toolbox)
import Styles.Grid exposing (Class(..), withGridNamespace)


view : Model -> Html State.Msg
view model =
    div [ withGridNamespace.class [ ViewSize, Columns, VerticalColumns ] ]
        [ Html.header [ headerClasses ] (Header.View.header model)
        , div [ withGridNamespace.class [ Columns, Column ] ]
            [ toolbox model
            , navigator model
            , visualizer model.xpdl
            ]
        ]
