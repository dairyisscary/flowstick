module XPDL.Process exposing (Processes, ProcessId, processesFromJson)

import Dict exposing (..)
import XPDL.Lane exposing (Lanes, LaneId)
import Json.XPDL.Package exposing (Package)
import Json.XPDL.Process as XProc


type alias ProcessId =
    String


type alias Process =
    { id : ProcessId
    , name : String
    , lanes : List LaneId
    }


type alias Processes =
    Dict ProcessId Process


createDict : (a -> comparable) -> (a -> b) -> List a -> Dict comparable b
createDict pluckFunc func =
    fromList << List.map (\item -> ( pluckFunc item, func item ))


findInList : (a -> Bool) -> List a -> Maybe a
findInList pred list =
    case list of
        [] ->
            Nothing

        x :: xs ->
            if pred x then
                Just x
            else
                findInList pred xs


processFromJson : Package -> XProc.Process -> Process
processFromJson package xproc =
    let
        procId =
            xproc.id

        maybePools =
            findInList (\p -> p.process == procId) package.pools

        maybeLanes =
            maybePools `Maybe.andThen` (Just << .lanes)

        lanes =
            maybeLanes `Maybe.andThen` (Just << List.map .id)
    in
        { id = procId
        , name = xproc.name
        , lanes = Maybe.withDefault [] lanes
        }


processesFromJson : Package -> Processes
processesFromJson package =
    createDict (.id) (processFromJson package) package.processes
