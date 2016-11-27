module Drag exposing (onMouseDownStartDragging, update, subscriptions, init, draggingData)

import State exposing (Msg(..), Model, Point, DragInfo(..))
import Mouse exposing (ups, moves)
import Html exposing (Attribute)
import Html.Events exposing (defaultOptions, onWithOptions)
import Json.Decode as Json exposing (Decoder, field, map, int, map2)
import XPDL.Activity exposing (ActivityId)


init : DragInfo
init =
    NotDragging


computeDiff : Point -> { x : Int, y : Int } -> Point
computeDiff start mousePos =
    ( mousePos.x - Tuple.first start
    , mousePos.y - Tuple.second start
    )


update : State.Msg -> DragInfo -> ( DragInfo, Cmd msg )
update msg dragInfo =
    case msg of
        SelectActivity _ point ->
            ( Dragging
                { start = point
                , diffX = 0
                , diffY = 0
                }
            , Cmd.none
            )

        StopDragging ->
            ( init, Cmd.none )

        Move ( newX, newY ) ->
            case dragInfo of
                Dragging info ->
                    ( Dragging { info | diffX = newX, diffY = newY }, Cmd.none )

                _ ->
                    ( dragInfo, Cmd.none )

        _ ->
            ( dragInfo, Cmd.none )


subscriptions : DragInfo -> Sub Msg
subscriptions dragInfo =
    case dragInfo of
        Dragging info ->
            Sub.batch
                [ moves (Move << computeDiff info.start)
                , ups (\_ -> StopDragging)
                ]

        _ ->
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


draggingData :
    DragInfo
    -> ({ diffX : Int, diffY : Int, start : Point } -> a)
    -> a
    -> a
draggingData dragInfo fn default =
    case dragInfo of
        Dragging info ->
            fn info

        _ ->
            default
