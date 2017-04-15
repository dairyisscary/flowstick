module Json.Decode.Xpdl.Performer exposing (performerDecoder, Performer)

import Json.Decode exposing (..)
import Json.Decode.Maybe exposing (maybeWithDefault)
import Json.Decode.XML exposing (listOfOne)


type alias Performer =
    String


performerDecoder : Decoder Performer
performerDecoder =
    maybeWithDefault "" (field "xpdl:Performer" (listOfOne string))
