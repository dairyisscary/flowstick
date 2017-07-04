module Json.Decode.Xpdl.Transition exposing (Transition, Transitions, TransitionId, transitionsDecoder)

import Json.Decode exposing (..)
import Json.Decode.Maybe exposing (maybeWithDefault)
import Json.Decode.Xml exposing (listOfOne)


type alias Anchor =
    { x : Int, y : Int }


type alias Anchors =
    List Anchor


type alias Transition =
    { id : TransitionId
    , name : Maybe String
    , to : String
    , from : String
    , anchors : Anchors
    }


type alias TransitionAttributes =
    { id : TransitionId
    , name : Maybe String
    , to : String
    , from : String
    }


type alias GraphicInfos =
    { anchors : Anchors }


type alias Transitions =
    List Transition


type alias TransitionId =
    String


anchorDecoder : Decoder (Maybe Anchor)
anchorDecoder =
    let
        convertToInt =
            String.toInt >> Result.toMaybe

        makeAnchor maybeX maybeY =
            Maybe.map2 Anchor
                (Maybe.andThen convertToInt maybeX)
                (Maybe.andThen convertToInt maybeY)
    in
        map2 makeAnchor
            (maybe (at [ "$", "XCoordinate" ] string))
            (maybe (at [ "$", "YCoordinate" ] string))


anchorsDecoder : Decoder Anchors
anchorsDecoder =
    let
        makeAnchors : Maybe String -> List (Maybe Anchor) -> Anchors
        makeAnchors style anchors =
            case style of
                Just "NO_ROUTING_ORTHOGONAL" ->
                    List.filterMap identity anchors

                _ ->
                    []
    in
        map2 makeAnchors
            (maybeWithDefault Nothing (maybe (at [ "$", "Style" ] string)))
            (maybeWithDefault [] (field "xpdl:Coordinates" (list anchorDecoder)))


graphicInfosDecoder : Decoder GraphicInfos
graphicInfosDecoder =
    map (GraphicInfos << List.concatMap identity)
        (maybeWithDefault [] (field "xpdl:ConnectorGraphicsInfo" (list anchorsDecoder)))


transitionAttributesDecoder : Decoder TransitionAttributes
transitionAttributesDecoder =
    map4 TransitionAttributes
        (field "Id" string)
        (maybe (field "Name" string))
        (field "To" string)
        (field "From" string)


makeTransitions : TransitionAttributes -> GraphicInfos -> Transition
makeTransitions { id, name, to, from } { anchors } =
    Transition id name to from anchors


transitionDecoder : Decoder Transition
transitionDecoder =
    map2 makeTransitions
        (field "$" transitionAttributesDecoder)
        (maybeWithDefault { anchors = [] } (field "xpdl:ConnectorGraphicsInfos" (listOfOne graphicInfosDecoder)))


transitionsDecoder : Decoder Transitions
transitionsDecoder =
    maybeWithDefault [] (field "xpdl:Transition" (list transitionDecoder))
