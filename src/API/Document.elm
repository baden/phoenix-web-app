module API.Document exposing (..)

import Json.Encode as Encode


updateDocumentRequest : String -> Encode.Value -> Encode.Value
updateDocumentRequest name query =
    Encode.object
        [ ( "cmd", Encode.string "update_document" )
        , ( "collection", Encode.string name )
        , ( "query", query )
        ]
