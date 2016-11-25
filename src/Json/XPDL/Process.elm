module Json.XPDL.Process exposing (Processes, Process, ProcessId, processesDecoder)

import Json.Decode exposing (Decoder, list, nullable, string)
import Json.Decode.Pipeline exposing (decode, optional, required)
import Json.Decode.XML exposing (listOfOne)
import Json.XPDL.Activity exposing (Activities, activitiesDecoder)
import Json.XPDL.Transition exposing (Transitions, transitionsDecoder)


type alias ProcessId =
    String


type alias Process =
    { id : ProcessId
    , name : String
    , activities : Activities
    , transitions : Transitions
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
    -> Maybe Transitions
    -> Process
makeProcessFromDecode attrs maybeActs maybeTrans =
    let
        acts =
            Maybe.withDefault [] maybeActs

        trans =
            Maybe.withDefault [] maybeTrans
    in
        Process attrs.id attrs.name acts trans


processDecoder : Decoder Process
processDecoder =
    decode makeProcessFromDecode
        |> required "$" processAttributesDecoder
        |> optional "xpdl:Activities" (nullable (listOfOne activitiesDecoder)) Nothing
        |> optional "xpdl:Transitions" (nullable (listOfOne transitionsDecoder)) Nothing


processesDecoder : Decoder Processes
processesDecoder =
    decode identity
        |> optional "xpdl:WorkflowProcess" (list processDecoder) []
