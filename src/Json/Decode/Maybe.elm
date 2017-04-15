module Json.Decode.Maybe exposing (maybeWithDefault)

import Json.Decode exposing (Decoder, map, maybe)
import Maybe exposing (withDefault)


maybeWithDefault : a -> Decoder a -> Decoder a
maybeWithDefault fallback decoder =
    map (withDefault fallback) (maybe decoder)
