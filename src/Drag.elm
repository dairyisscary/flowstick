module Drag exposing (Msg(..), DragInfo, onClickStartDragging, update, subscriptions, init)

import Mouse exposing (ups, moves)
import Html exposing (Attribute)
import Html.Events exposing (defaultOptions, onWithOptions)
import Json.Decode as Json exposing (Decoder, field, map, int, map2)


type alias DragInfo =
    { isDragging : Bool
    , start : Point
    , diffX : Int
    , diffY : Int
    }


type alias Point =
    ( Int, Int )


type Msg
    = StartDragging Point
    | StopDragging
    | Move Point


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


update : Msg -> DragInfo -> ( DragInfo, Cmd msg )
update msg dragInfo =
    case msg of
        StartDragging point ->
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


subscriptions : DragInfo -> Sub Msg
subscriptions dragInfo =
    if dragInfo.isDragging then
        Sub.batch
            [ moves (Move << computeDiff dragInfo.start)
            , ups (\_ -> StopDragging)
            ]
    else
        Sub.none


onClickStartDragging : (Msg -> msg) -> Attribute msg
onClickStartDragging actionFn =
    onWithOptions
        "mousedown"
        defaultOptions
        (Json.map (actionFn << StartDragging) decodeMousePosition)


decodeMousePosition : Decoder Point
decodeMousePosition =
    map2 (,) (field "pageX" int) (field "pageY" int)
