module Main exposing (..)

import Html exposing (Html, text, div, button, input)
import Html.Events exposing (onClick, onInput)
import Html.App
import XPDL


type alias Model =
    { xpdl : XPDL.XPDL
    , filename : String
    }


init : ( Model, Cmd Msg )
init =
    ( Model "nothing" "", Cmd.none )


type Msg
    = UpdateFilename String
    | XPDLMsg (XPDL.Msg)


view : Model -> Html Msg
view model =
    div []
        [ input [ onInput UpdateFilename ] []
        , button [ onClick (XPDLMsg (XPDL.ReadXPDL model.filename)) ] [ text "Load!" ]
        , div [] [ text ("XPDL is " ++ model.xpdl) ]
        ]


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    case msg of
        UpdateFilename fn ->
            ( { model | filename = fn }, Cmd.none )

        XPDLMsg xpdlMsg ->
            let
                ( newXpdl, xpdlCmd ) =
                    XPDL.update xpdlMsg model.xpdl
            in
                ( { model | xpdl = newXpdl }, xpdlCmd )


subscriptions : Model -> Sub Msg
subscriptions model =
    Sub.batch
        [ Sub.map XPDLMsg (XPDL.subscriptions model.xpdl) ]


main : Program Never
main =
    Html.App.program
        { init = init
        , view = view
        , update = update
        , subscriptions = subscriptions
        }
