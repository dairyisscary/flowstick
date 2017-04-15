module Json.Decode.Xpdl.Transition exposing (Transition, Transitions, TransitionId, transitionsDecoder)

import Json.Decode exposing (..)
import Json.Decode.Maybe exposing (maybeWithDefault)
import Json.Decode.XML exposing (listOfOne)


type alias Anchors =
    List { x : Int, y : Int }


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


type alias Transitions =
    List Transition


type alias TransitionId =
    String


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

        cordinateDecoder : String -> Decoder (Maybe String)
        cordinateDecoder propName =
            maybe (index 0 (at [ "$", propName ] string))
    in
        map3 makeAnchor
            (maybeWithDefault Nothing (field "$" (maybe (field "Style" string))))
            (maybeWithDefault Nothing (field "xpdl:Coordinates" <| cordinateDecoder "XCoordinate"))
            (maybeWithDefault Nothing (field "xpdl:Coordinates" <| cordinateDecoder "YCoordinate"))


anchorsDecoder : Decoder Anchors
anchorsDecoder =
    map (List.filterMap identity)
        (maybeWithDefault [] (field "xpdl:ConnectorGraphicsInfo" (list anchorDecoder)))


transitionAttributesDecoder : Decoder TransitionAttributes
transitionAttributesDecoder =
    map4 TransitionAttributes
        (field "Id" string)
        (maybe (field "Name" string))
        (field "To" string)
        (field "From" string)


makeTransitions : TransitionAttributes -> Anchors -> Transition
makeTransitions { id, name, to, from } =
    Transition id name to from


transitionDecoder : Decoder Transition
transitionDecoder =
    map2 makeTransitions
        (field "$" transitionAttributesDecoder)
        (maybeWithDefault [] (field "xpdl:ConnectorGraphicsInfos" (listOfOne anchorsDecoder)))


transitionsDecoder : Decoder Transitions
transitionsDecoder =
    maybeWithDefault [] (field "xpdl:Transition" (list transitionDecoder))
