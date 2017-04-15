module Json.Decode.Xml exposing (listOfOne, intFromString)

import String exposing (toInt)
import Json.Decode as JD


checkList : JD.Decoder a -> List JD.Value -> JD.Decoder a
checkList itemDecoder list =
    case list of
        _ :: [] ->
            JD.index 0 itemDecoder

        _ ->
            JD.fail "Expecting excatly one element."


{-| Given a Decoder, return a new decoder that uses this Decoder at the first index
of a json array. If the list is not of length one, the Result is an Err.
-}
listOfOne : JD.Decoder a -> JD.Decoder a
listOfOne itemDecoder =
    JD.list JD.value |> JD.andThen (checkList itemDecoder)


convertToInt : String -> JD.Decoder Int
convertToInt str =
    case toInt str of
        Ok int ->
            JD.succeed int

        Err e ->
            JD.fail e


{-| Returns a decoder that reads from XML as a string but returns an Int.
-}
intFromString : JD.Decoder Int
intFromString =
    JD.string |> JD.andThen convertToInt
