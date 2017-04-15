module Navigator.View exposing (navigator)

import Dict exposing (get)
import Html exposing (..)
import Html.CssHelpers exposing (withNamespace)
import Html.Events exposing (onClick)
import Navigator.Styles exposing (Class(..))
import State exposing (Msg(ChangeCurrentProcess), Model)
import Styles.Namespace exposing (Namespace(Navigator), FlowstickNamespace)
import Xpdl.Process exposing (ProcessId)
import Xpdl.State exposing (XPDLState, XPDL(Loaded))


ns : FlowstickNamespace Class id msg
ns =
    withNamespace Styles.Namespace.Navigator


processListing : XPDLState -> ProcessId -> Html State.Msg
processListing state procId =
    let
        procName =
            get procId state.processes
                |> Maybe.map (.name)
                |> Maybe.withDefault procId
    in
        li
            [ ns.classList [ ( CurrentProcess, state.currentProcess == Just procId ) ]
            , onClick <| ChangeCurrentProcess procId
            ]
            [ text procName ]


processListings : Model -> List (Html State.Msg)
processListings model =
    case model.xpdl of
        Loaded state ->
            List.map (processListing state) state.entries

        _ ->
            [ li [] [ text "nothing here either" ] ]


navigator : Model -> Html State.Msg
navigator model =
    div [ ns.class [ Navigator.Styles.Navigator ] ]
        [ ul [] (processListings model) ]
