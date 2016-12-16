module History exposing (History, compose, initializeHistory)

import State exposing (Msg(Undo, Redo))


type alias History a =
    { past : List a
    , present : a
    , future : List a
    , lastInterestingPresent : Maybe a
    }


initializeHistory : a -> History a
initializeHistory val =
    { past = []
    , present = val
    , future = []
    , lastInterestingPresent = Nothing
    }


compose :
    (Msg -> Bool)
    -> (Msg -> Bool)
    -> (Msg -> b -> ( b, Cmd msg ))
    -> Msg
    -> History b
    -> ( History b, Cmd msg )
compose historyFilter msgFilter update msg history =
    case msg of
        Undo ->
            ( undo history, Cmd.none )

        Redo ->
            ( redo history, Cmd.none )

        _ ->
            passthrough historyFilter msgFilter update msg history


passthrough :
    (Msg -> Bool)
    -> (Msg -> Bool)
    -> (Msg -> b -> ( b, Cmd msg ))
    -> Msg
    -> History b
    -> ( History b, Cmd msg )
passthrough historyFilter msgFilter update msg history =
    let
        ( newPresent, cmd ) =
            update msg history.present

        oldLastInterest =
            history.lastInterestingPresent

        shouldAddPast =
            -- Only add to history if we have an interesting present to add
            -- and its not the same as the last past state
            -- and it passses the msgFilter
            oldLastInterest /= Nothing && oldLastInterest /= List.head history.past && msgFilter msg

        newHistory =
            { past =
                if shouldAddPast then
                    Maybe.withDefault newPresent oldLastInterest :: history.past
                else
                    history.past
            , present = newPresent
            , future = []
            , lastInterestingPresent =
                if historyFilter msg then
                    Just newPresent
                else
                    oldLastInterest
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
            , lastInterestingPresent = oldHist.lastInterestingPresent
            }

        _ ->
            oldHist


redo : History a -> History a
redo oldHist =
    case oldHist.future of
        x :: xs ->
            { past = oldHist.present :: oldHist.past
            , present = x
            , future = xs
            , lastInterestingPresent = oldHist.lastInterestingPresent
            }

        _ ->
            oldHist
