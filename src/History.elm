module History exposing (History, compose, initializeHistory)


type alias History a =
    { past : List a
    , present : a
    , future : List a
    }


initializeHistory : a -> History a
initializeHistory val =
    { past = [], present = val, future = [] }


compose : (a -> b -> ( b, c )) -> a -> History b -> ( History b, c )
compose update msg history =
    let
        ( newPresent, cmd ) =
            update msg history.present

        newHistory =
            { past = history.present :: history.past
            , present = newPresent
            , future = []
            }
    in
        ( newHistory, cmd )
