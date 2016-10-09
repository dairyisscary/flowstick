module XPDL.Process exposing (Processes, Process, ProcessId, processesDecoder)

import Json.Decode exposing (Decoder, list, string)
import Json.Decode.Pipeline exposing (decode, optional, nullable, required)
import Json.Decode.XML exposing (listOfOne)
import XPDL.Activity exposing (Activities, activitiesDecoder)


type alias ProcessId =
    String


type alias Process =
    { id : ProcessId
    , name : String
    , activites : Activities
    }


type alias Processes =
    List Process


processAttributesDecoder : Decoder { id : String, name : String }
processAttributesDecoder =
    decode (\id name -> { id = id, name = name })
        |> required "Id" string
        |> optional "Name" string ""


makeProcessFromDecode :
    { id : String, name : String }
    -> Maybe Activities
    -> Process
makeProcessFromDecode attrs maybeActs =
    let
        acts =
            Maybe.withDefault [] maybeActs
    in
        Process attrs.id attrs.name acts


processDecoder : Decoder Process
processDecoder =
    decode makeProcessFromDecode
        |> required "$" processAttributesDecoder
        |> optional "xpdl:Activities" (nullable (listOfOne activitiesDecoder)) Nothing


processesDecoder : Decoder Processes
processesDecoder =
    decode identity
        |> optional "xpdl:WorkflowProcess" (list processDecoder) []
