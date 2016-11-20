module State exposing (Model, Msg(..), Point, DragInfo)

import XPDL.State as XS
import XPDL.File as File
import XPDL.Process exposing (ProcessId)
import XPDL.Activity exposing (ActivityId)
import Json.XPDL as JX


type alias Point =
    ( Int, Int )


type Msg
    = JSONMsg JX.Msg
    | FileMsg File.Msg
    | ChangeCurrentProcess ProcessId
    | SelectActivity ActivityId
    | StartDragging Point
    | StopDragging
    | Move Point


type alias DragInfo =
    { isDragging : Bool
    , start : Point
    , diffX : Int
    , diffY : Int
    }


type alias Model =
    { xpdl : XS.XPDL
    , drag : DragInfo
    }
