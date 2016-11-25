module Json.XPDL.Transition exposing (Transition, Transitions, TransitionId, transitionsDecoder)

import Json.Decode exposing (Decoder, list, string, nullable)
import Json.Decode.Pipeline exposing (decode, optional, required)


type alias Transition =
    { id : TransitionId
    , name : Maybe String
    , to : String
    , from : String
    }


type alias Transitions =
    List Transition


type alias TransitionId =
    String


transitionAttributesDecoder : Decoder Transition
transitionAttributesDecoder =
    decode Transition
        |> required "Id" string
        |> optional "Name" (nullable string) Nothing
        |> required "To" string
        |> required "From" string


transitionDecoder : Decoder Transition
transitionDecoder =
    decode identity
        |> required "$" transitionAttributesDecoder


transitionsDecoder : Decoder Transitions
transitionsDecoder =
    decode identity
        |> optional "xpdl:Transition" (list transitionDecoder) []
