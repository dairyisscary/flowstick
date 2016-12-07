module History exposing (History, compose, initializeHistory)


type alias History a =
    { past : List a
    , present : a
    , future : List a
    }


initializeHistory : a -> History a
initializeHistory val =
    { past = [], present = val, future = [] }


compose : (a -> Bool) -> (a -> b -> ( b, c )) -> a -> History b -> ( History b, c )
compose filter update msg history =
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
