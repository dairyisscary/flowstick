module List.Extra exposing (find)


find : (a -> Bool) -> List a -> Maybe a
find f l =
    case l of
        [] ->
            Nothing

        x :: xs ->
            if f x then
                Just x
            else
                find f xs
