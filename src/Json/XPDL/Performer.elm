module Json.XPDL.Performer exposing (performerDecoder, Performer)

import Json.Decode exposing (Decoder, string, list)
import Json.Decode.Pipeline exposing (decode, optional)


type alias Performer =
    String


makePerformerFromDecode : List Performer -> Performer
makePerformerFromDecode =
    Maybe.withDefault "" << List.head


performerDecoder : Decoder Performer
performerDecoder =
    decode makePerformerFromDecode
        |> optional "xpdl:Performer" (list string) []
