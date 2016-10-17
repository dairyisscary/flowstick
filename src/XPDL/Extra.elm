module XPDL.Extra exposing (find, createDict)

import Dict exposing (Dict, fromList)


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


createDict : (a -> comparable) -> (a -> b) -> List a -> Dict comparable b
createDict pluckFunc func =
    fromList << List.map (\item -> ( pluckFunc item, func item ))
