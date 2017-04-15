module Json.Decode.Xpdl.Activity exposing (Activities, Activity, activitiesDecoder)

import Json.Decode exposing (..)
import Json.Decode.Maybe exposing (maybeWithDefault)
import Json.Decode.XML exposing (listOfOne, intFromString)
import Json.Decode.Xpdl.Lane exposing (LaneId)


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


type alias ActivityAttributes =
    { id : String, name : Maybe String }


makeGraphicsInfoFromDecode : ( LaneId, { x : Int, y : Int } ) -> ActivityGraphicsInfo
makeGraphicsInfoFromDecode ( lane, { x, y } ) =
    { lane = lane, x = x, y = y }


activityGraphicsDecoder : Decoder ActivityGraphicsInfo
activityGraphicsDecoder =
    let
        cordsDecoder =
            map2 (\x y -> { x = x, y = y })
                (at [ "$", "XCoordinate" ] intFromString)
                (at [ "$", "YCoordinate" ] intFromString)

        singleDecoder =
            map2 (,)
                (at [ "$", "LaneId" ] string)
                (field "xpdl:Coordinates" (listOfOne cordsDecoder))
    in
        map makeGraphicsInfoFromDecode
            (field "xpdl:NodeGraphicsInfo" (listOfOne singleDecoder))


activityAttributesDecoder : Decoder { id : String, name : Maybe String }
activityAttributesDecoder =
    map2 ActivityAttributes
        (field "Id" string)
        (maybe (field "Name" string))


makeActivityFromDecode :
    ActivityAttributes
    -> ActivityGraphicsInfo
    -> Activity
makeActivityFromDecode { id, name } =
    Activity id name


activityDecoder : Decoder Activity
activityDecoder =
    map2 makeActivityFromDecode
        (field "$" activityAttributesDecoder)
        (field "xpdl:NodeGraphicsInfos" (listOfOne activityGraphicsDecoder))


activitiesDecoder : Decoder Activities
activitiesDecoder =
    maybeWithDefault [] (field "xpdl:Activity" (list activityDecoder))
