module View exposing (view)

import Html exposing (..)
import Html.Attributes exposing (..)
import Html.Events exposing (..)
import State exposing (Model, Msg, Msg(UpdateFilename), readFile)


view : Model -> Html Msg
view model =
    div []
        [ input [ onInput UpdateFilename, value model.filename ] []
        , button [ onClick (readFile model.filename) ] [ text "Load!" ]
        , div [] [ text ("state is " ++ (toString model)) ]
        ]
