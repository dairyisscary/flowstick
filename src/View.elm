module View exposing (view)

import Html exposing (..)
import Html.Attributes exposing (..)
import State exposing (Model, Msg)
import Visualizer.View exposing (visualizer)
import Header.View exposing (header)
import Styles.Grid exposing (Class(..), withGridNamespace)


view : Model -> Html State.Msg
view model =
    div [ withGridNamespace.class [ ViewSize, Columns, VerticalColumns ] ]
        [ Html.header [] (Header.View.header model)
        , div [ withGridNamespace.class [ Columns, Column ] ]
            [ div [ style [ ( "width", "400px" ) ] ] [ text "navigator" ]
            , visualizer model.xpdl
            ]
        ]
