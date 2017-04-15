module XPDL.Activity exposing (Activities, Activity, ActivityId, activitiesFromJson)

import Dict exposing (Dict)
import Json.Decode.Xpdl.Activity as JAct
import Json.Decode.Xpdl.Package exposing (Package)
import XPDL.Extra exposing (createDict)
import XPDL.Lane exposing (LaneId)


type alias Activity =
    { id : ActivityId
    , name : Maybe String
    , lane : LaneId
    , x : Int
    , y : Int
    , selected : Bool
    }


type alias ActivityId =
    String


type alias Activities =
    Dict ActivityId Activity


activityFromJson : JAct.Activity -> Activity
activityFromJson act =
    let
        graphicsInfo =
            act.graphicsInfo
    in
        { id = act.id
        , name = act.name
        , lane = graphicsInfo.lane
        , x = graphicsInfo.x
        , y = graphicsInfo.y
        , selected = False
        }


activitiesFromJson : Package -> Activities
activitiesFromJson package =
    let
        allActs =
            List.concatMap (.activities) package.processes
    in
        createDict (.id) activityFromJson allActs
