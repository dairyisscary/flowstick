module XPDL.Activity exposing (Activities, activitiesDecoder)

import XPDL.Transition exposing (TransitionId)
import XPDL.Lane exposing (LaneId)
import Dict exposing (Dict, fromList)
import Json.Decode exposing (Decoder, list, string)
import Json.Decode.Pipeline exposing (decode, optional, nullable)


type alias ActivityId =
    String


type alias Activities =
    Dict ActivityId Activity


type alias Activity =
    { id :
        ActivityId
        --, x : Int
        --, y : Int
        --, lane : LaneId
        --, to : Maybe TransitionId
        --, from : Maybe TransitionId
    }


activityAttributesDecoder : Decoder { id : Maybe String }
activityAttributesDecoder =
    decode (\ms -> { id = ms })
        |> optional "Id" (nullable string) Nothing


makeActivityFromDecode : Maybe { id : Maybe String } -> Activity
makeActivityFromDecode maybeAttrs =
    let
        id =
            Maybe.withDefault "" (maybeAttrs `Maybe.andThen` .id)
    in
        Activity id


activityDecoder : Decoder Activity
activityDecoder =
    decode makeActivityFromDecode
        |> optional "$" (nullable activityAttributesDecoder) Nothing


makeActivitesFromDecode : Maybe (List Activity) -> Activities
makeActivitesFromDecode maybeActs =
    let
        listActs =
            Maybe.withDefault [] maybeActs
    in
        fromList (List.map (\a -> ( a.id, a )) listActs)


activitiesDecoder : Decoder Activities
activitiesDecoder =
    decode makeActivitesFromDecode
        |> optional "xpdl:Activity" (nullable (list activityDecoder)) Nothing
