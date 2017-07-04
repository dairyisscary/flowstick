module Xpdl.Transition exposing (Transitions, Transition, TransitionId, transitionsFromJson)

import Dict exposing (Dict)
import Json.Decode.Xpdl.Package exposing (Package)
import Json.Decode.Xpdl.Transition as JTrans
import Xpdl.Activity exposing (ActivityId)
import Xpdl.Extra exposing (createDict)


type alias TransitionId =
    String


type alias Transitions =
    Dict TransitionId Transition


type alias Anchor =
    { x : Int, y : Int, selected : Bool }


type alias Transition =
    { id : TransitionId
    , name : Maybe String
    , to : ActivityId
    , from : ActivityId
    , anchors : List Anchor
    , selected : Bool
    }


transitionFromJson : JTrans.Transition -> Transition
transitionFromJson { id, name, to, from, anchors } =
    { id = id
    , name = name
    , to = to
    , from = from
    , anchors = List.map (\{ x, y } -> { x = x, y = y, selected = False }) anchors
    , selected = False
    }


transitionsFromJson : JTrans.Transitions -> Transitions
transitionsFromJson =
    createDict (.id) transitionFromJson
