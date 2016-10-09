module Json.Decode.XML exposing (listOfOne)

import Json.Decode exposing (Decoder, Value, decodeValue, customDecoder, value, list)


checkList : Decoder a -> List Value -> Result String a
checkList itemDecoder list =
    case list of
        one :: [] ->
            (decodeValue itemDecoder one)

        _ ->
            Err "Expecting excatly one element."


{-| Given a Decoder, return a new decoder that uses this Decoder at the first index
of a json array. If the list is not of length one, the Result is an Err.
-}
listOfOne : Decoder a -> Decoder a
listOfOne itemDecoder =
    customDecoder (list value) (checkList itemDecoder)
