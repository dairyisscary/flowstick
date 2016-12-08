module History exposing (History, compose, initializeHistory)

import State exposing (Msg(Undo))


type alias History a =
    { past : List a
    , present : a
    , future : List a
    }


initializeHistory : a -> History a
initializeHistory val =
    { past = [], present = val, future = [] }


compose : (Msg -> Bool) -> (Msg -> b -> ( b, Cmd msg )) -> Msg -> History b -> ( History b, Cmd msg )
compose filter update msg history =
    case msg of
        Undo ->
            ( undo history, Cmd.none )

        _ ->
            passthrough filter update msg history


passthrough : (Msg -> Bool) -> (Msg -> b -> ( b, Cmd msg )) -> Msg -> History b -> ( History b, Cmd msg )
passthrough filter update msg history =
    let
        ( newPresent, cmd ) =
            update msg history.present

        newHistory =
            { past =
                if filter msg then
                    history.present :: history.past
                else
                    history.past
            , present = newPresent
            , future = []
            }
    in
        ( newHistory, cmd )


undo : History a -> History a
undo oldHist =
    case oldHist.past of
        x :: xs ->
            { past = xs
            , present = x
            , future = oldHist.present :: oldHist.future
            }

        _ ->
            oldHist
