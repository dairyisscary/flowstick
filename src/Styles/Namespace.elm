module Styles.Namespace exposing (Namespace(..), FlowstickNamespace)

import Html.CssHelpers exposing (Namespace)


type Namespace
    = Grid
    | Visualizer
    | Navigator
    | Header


type alias FlowstickNamespace class id msg =
    Html.CssHelpers.Namespace Namespace class id msg
