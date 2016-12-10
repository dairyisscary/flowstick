module State exposing (Model, Msg(..), Point, DragInfo(..))

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
    | DeselectAllActivities
    | SelectActivity ActivityId Point
    | StopDragging
    | Move Point
    | Undo
    | Redo


type DragInfo
    = NotDragging
    | Dragging
        { start : Point
        , diffX : Int
        , diffY : Int
        }


type alias Model =
    { xpdl : XS.XPDL
    , drag : DragInfo
    }
