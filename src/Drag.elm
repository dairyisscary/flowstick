module Drag exposing (onMouseDownStartDragging, update, subscriptions, init)

import State exposing (Msg(..), Model, Point, DragInfo)
import Mouse exposing (ups, moves)
import Html exposing (Attribute)
import Html.Events exposing (defaultOptions, onWithOptions)
import Json.Decode as Json exposing (Decoder, field, map, int, map2)
import XPDL.Activity exposing (ActivityId)


init : DragInfo
init =
    { isDragging = False
    , start = ( 0, 0 )
    , diffX = 0
    , diffY = 0
    }


computeDiff : Point -> { x : Int, y : Int } -> Point
computeDiff start mousePos =
    ( mousePos.x - Tuple.first start
    , mousePos.y - Tuple.second start
    )


update : State.Msg -> DragInfo -> ( DragInfo, Cmd msg )
update msg dragInfo =
    case msg of
        SelectActivity _ point ->
            ( { isDragging = True
              , start = point
              , diffX = 0
              , diffY = 0
              }
            , Cmd.none
            )

        StopDragging ->
            ( init, Cmd.none )

        Move ( newX, newY ) ->
            -- Check to make sure we're dragging. Sometimes some Move messages
            -- come after StopDragging has been issued.
            if dragInfo.isDragging then
                ( { dragInfo | diffX = newX, diffY = newY }, Cmd.none )
            else
                ( dragInfo, Cmd.none )

        _ ->
            ( dragInfo, Cmd.none )


subscriptions : DragInfo -> Sub Msg
subscriptions dragInfo =
    if dragInfo.isDragging then
        Sub.batch
            [ moves (Move << computeDiff dragInfo.start)
            , ups (\_ -> StopDragging)
            ]
    else
        Sub.none


onMouseDownStartDragging : Bool -> ActivityId -> Attribute Msg
onMouseDownStartDragging blockPropgation actId =
    onWithOptions
        "mousedown"
        { stopPropagation = blockPropgation, preventDefault = False }
        (Json.map (SelectActivity actId) decodeMousePosition)


decodeMousePosition : Decoder Point
decodeMousePosition =
    map2 (,) (field "pageX" int) (field "pageY" int)
