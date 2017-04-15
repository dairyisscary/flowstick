module Json.Decode.Xpdl.Process exposing (Processes, Process, ProcessId, processesDecoder)

import Json.Decode exposing (..)
import Json.Decode.Maybe exposing (maybeWithDefault)
import Json.Decode.XML exposing (listOfOne)
import Json.Decode.Xpdl.Activity exposing (Activities, activitiesDecoder)
import Json.Decode.Xpdl.Transition exposing (Transitions, transitionsDecoder)


type alias ProcessId =
    String


type alias Process =
    { id : ProcessId
    , name : String
    , activities : Activities
    , transitions : Transitions
    }


type alias ProcessAttributes =
    { id : String
    , name : String
    }


type alias Processes =
    List Process


processAttributesDecoder : Decoder { id : String, name : String }
processAttributesDecoder =
    map2 ProcessAttributes
        (field "Id" string)
        (maybeWithDefault "" (field "Name" string))


makeProcessFromDecode :
    ProcessAttributes
    -> Activities
    -> Transitions
    -> Process
makeProcessFromDecode { id, name } =
    Process id name


processDecoder : Decoder Process
processDecoder =
    map3 makeProcessFromDecode
        (field "$" processAttributesDecoder)
        (maybeWithDefault [] (field "xpdl:Activities" (listOfOne activitiesDecoder)))
        (maybeWithDefault [] (field "xpdl:Transitions" (listOfOne transitionsDecoder)))


processesDecoder : Decoder Processes
processesDecoder =
    maybeWithDefault [] (field "xpdl:WorkflowProcess" (list processDecoder))
