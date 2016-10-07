module XPDL.Performer exposing (Performer, performerDecoder)

import Json.Decode exposing (Decoder, string, list)
import Json.Decode.Pipeline exposing (decode, nullable, optional)


type alias Performer =
    String


makePerformer : Maybe (List String) -> Performer
makePerformer maybePerfList =
    Maybe.withDefault "" (maybePerfList `Maybe.andThen` List.head)


performerDecoder : Decoder Performer
performerDecoder =
    decode makePerformer
        |> optional "xpdl:Performer" (nullable (list string)) Nothing
