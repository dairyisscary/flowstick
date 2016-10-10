module Json.XPDL.Performer exposing (Performer, performerDecoder)

import Json.Decode exposing (Decoder, string, list)
import Json.Decode.Pipeline exposing (decode, nullable, optional)


type alias Performer =
    String


makePerformerFromDecode : List Performer -> Performer
makePerformerFromDecode =
    Maybe.withDefault "" << List.head


performerDecoder : Decoder Performer
performerDecoder =
    decode makePerformerFromDecode
        |> optional "xpdl:Performer" (list string) []
