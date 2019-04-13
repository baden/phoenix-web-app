module API.Admin exposing (..)

import Json.Encode as Encode


-- Запрос на модификацию списка систем


accountSystemPush : String -> Encode.Value
accountSystemPush skey =
    Encode.object
        [ ( "cmd", Encode.string "admin" )
        , ( "admin_cmd", Encode.string "document_update" )
        , ( "collection", Encode.string "account" )
        , ( "systems"
          , Encode.object
                [ ( "$push", Encode.string skey ) ]
          )
        ]
