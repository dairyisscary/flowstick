module Json.XPDL.Transition exposing (Transition, Transitions, TransitionId, transitionsDecoder)

import Json.Decode exposing (Decoder, field, maybe, at, index, list, string, nullable)
import Json.Decode.XML exposing (listOfOne)
import Json.Decode.Pipeline exposing (decode, optional, required, hardcoded)


type alias Anchors =
    List { x : Int, y : Int }


type alias Transition =
    { id : TransitionId
    , name : Maybe String
    , to : String
    , from : String
    , anchors : Anchors
    }


type alias TransitionAttrs =
    { id : TransitionId
    , name : Maybe String
    , to : String
    , from : String
    }


type alias Transitions =
    List Transition


type alias TransitionId =
    String


transitionAttributesDecoder : Decoder TransitionAttrs
transitionAttributesDecoder =
    decode TransitionAttrs
        |> required "Id" string
        |> optional "Name" (nullable string) Nothing
        |> required "To" string
        |> required "From" string


makeTransitions : TransitionAttrs -> Anchors -> Transition
makeTransitions attrs =
    Transition attrs.id attrs.name attrs.to attrs.from


anchorDecoder : Decoder (Maybe { x : Int, y : Int })
anchorDecoder =
    let
        convertCords : Maybe String -> Maybe Int
        convertCords =
            Maybe.andThen (String.toInt >> Result.toMaybe)

        makeAnchor : Maybe String -> Maybe String -> Maybe String -> Maybe { x : Int, y : Int }
        makeAnchor style xStr yStr =
            case style of
                Just "NO_ROUTING_ORTHOGONAL" ->
                    Maybe.map2 (\x y -> { x = x, y = y })
                        (convertCords xStr)
                        (convertCords yStr)

                _ ->
                    Nothing
    in
        decode makeAnchor
            |> optional "$" (maybe (field "Style" string)) Nothing
            |> optional "xpdl:Coordinates" (maybe (index 0 (at [ "$", "XCoordinate" ] string))) Nothing
            |> optional "xpdl:Coordinates" (maybe (index 0 (at [ "$", "YCoordinate" ] string))) Nothing


anchorsDecoder : Decoder Anchors
anchorsDecoder =
    decode (List.filterMap identity)
        |> optional "xpdl:ConnectorGraphicsInfo" (list anchorDecoder) []


transitionDecoder : Decoder Transition
transitionDecoder =
    decode makeTransitions
        |> required "$" transitionAttributesDecoder
        |> optional "xpdl:ConnectorGraphicsInfos" (listOfOne anchorsDecoder) []


transitionsDecoder : Decoder Transitions
transitionsDecoder =
    decode identity
        |> optional "xpdl:Transition" (list transitionDecoder) []
