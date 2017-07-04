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


type alias Transition =
    { id : TransitionId
    , name : Maybe String
    , to : ActivityId
    , from : ActivityId
    , anchors : List { x : Int, y : Int }
    }


transitionsFromJson : JTrans.Transitions -> Transitions
transitionsFromJson =
    createDict (.id) identity
