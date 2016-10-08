module XPDL.Process exposing (Processes, Process, ProcessId, processesDecoder)

import Dict exposing (Dict, fromList, empty)
import Json.Decode exposing (Decoder, list, string)
import Json.Decode.Pipeline exposing (decode, optional, nullable)
import XPDL.Activity exposing (Activities, activitiesDecoder)


type alias ProcessId =
    String


type alias Process =
    { id : ProcessId
    , name : String
    , acts : Activities
    }


type alias Processes =
    Dict ProcessId Process


processAttributesDecoder : Decoder { id : String, name : String }
processAttributesDecoder =
    let
        def =
            Maybe.withDefault ""
    in
        decode (\mi mn -> { id = def mi, name = def mn })
            |> optional "Id" (nullable string) Nothing
            |> optional "Name" (nullable string) Nothing


makeProcessFromDecode :
    Maybe { id : String, name : String }
    -> Maybe (List Activities)
    -> Process
makeProcessFromDecode maybeAttrs maybeActs =
    let
        defaultedDict =
            Maybe.withDefault empty << List.head << Maybe.withDefault []

        name =
            Maybe.withDefault "" (maybeAttrs `Maybe.andThen` (\x -> Just x.name))

        id =
            Maybe.withDefault "" (maybeAttrs `Maybe.andThen` (\x -> Just x.id))

        acts =
            defaultedDict maybeActs
    in
        Process id name acts


processDecoder : Decoder Process
processDecoder =
    decode makeProcessFromDecode
        |> optional "$" (nullable processAttributesDecoder) Nothing
        |> optional "xpdl:Activities" (nullable (list activitiesDecoder)) Nothing


makeProcessesFromDecode : Maybe (List Process) -> Processes
makeProcessesFromDecode maybeProcs =
    let
        defaultDict =
            fromList << List.map (\p -> ( p.id, p )) << Maybe.withDefault []
    in
        defaultDict maybeProcs


processesDecoder : Decoder Processes
processesDecoder =
    decode makeProcessesFromDecode
        |> optional "xpdl:WorkflowProcess" (nullable (list processDecoder)) Nothing
