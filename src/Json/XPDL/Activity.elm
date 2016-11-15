module Json.XPDL.Activity exposing (Activities, Activity, activitiesDecoder)

import Json.XPDL.Lane exposing (LaneId)
import Json.Decode exposing (Decoder, list, string, at, map2, nullable)
import Json.Decode.XML exposing (listOfOne, intFromString)
import Json.Decode.Pipeline exposing (decode, optional, required)


type alias ActivityId =
    String


type alias Activities =
    List Activity


type alias ActivityGraphicsInfo =
    { lane : LaneId
    , x : Int
    , y : Int
    }


type alias Activity =
    { id : ActivityId
    , name : Maybe String
    , graphicsInfo : ActivityGraphicsInfo
    }


makeGraphicsInfoFromDecode : ( LaneId, { x : Int, y : Int } ) -> ActivityGraphicsInfo
makeGraphicsInfoFromDecode ( lane, { x, y } ) =
    { lane = lane, x = x, y = y }


activityGraphicsDecoder : Decoder ActivityGraphicsInfo
activityGraphicsDecoder =
    let
        attrsDecoder =
            decode identity
                |> required "LaneId" string

        cordsDecoder =
            map2 (\x y -> { x = x, y = y })
                (at [ "$", "XCoordinate" ] intFromString)
                (at [ "$", "YCoordinate" ] intFromString)

        singleDecoder =
            decode (,)
                |> required "$" attrsDecoder
                |> required "xpdl:Coordinates" (listOfOne cordsDecoder)
    in
        decode makeGraphicsInfoFromDecode
            |> required "xpdl:NodeGraphicsInfo" (listOfOne singleDecoder)


activityAttributesDecoder : Decoder { id : String, name : Maybe String }
activityAttributesDecoder =
    decode (\id mn -> { id = id, name = mn })
        |> required "Id" string
        |> optional "Name" (nullable string) Nothing


makeActivityFromDecode :
    { id : String, name : Maybe String }
    -> ActivityGraphicsInfo
    -> Activity
makeActivityFromDecode attrs =
    Activity attrs.id attrs.name


activityDecoder : Decoder Activity
activityDecoder =
    decode makeActivityFromDecode
        |> required "$" activityAttributesDecoder
        |> required "xpdl:NodeGraphicsInfos" (listOfOne activityGraphicsDecoder)


activitiesDecoder : Decoder Activities
activitiesDecoder =
    decode identity
        |> optional "xpdl:Activity" (list activityDecoder) []
