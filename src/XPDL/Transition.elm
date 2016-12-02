module XPDL.Transition exposing (Transitions, Transition, TransitionId, transitionsFromJson)

import Dict exposing (Dict)
import XPDL.Extra exposing (createDict)
import XPDL.Activity exposing (ActivityId)
import Json.XPDL.Package exposing (Package)
import Json.XPDL.Transition as JTrans


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


transitionFromJson : JTrans.Transition -> Transition
transitionFromJson =
    identity


transitionsFromJson : Package -> Transitions
transitionsFromJson package =
    List.concatMap (.transitions) package.processes
        |> createDict (.id) transitionFromJson
