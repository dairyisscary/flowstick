module Xpdl.Extra exposing (createDict)

import Dict exposing (Dict, fromList)


createDict : (a -> comparable) -> (a -> b) -> List a -> Dict comparable b
createDict pluckFunc func =
    fromList << List.map (\item -> ( pluckFunc item, func item ))
