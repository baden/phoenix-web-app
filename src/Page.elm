-- module Page exposing (Page(..), view, viewErrors)


module Page exposing (..)

import API.System exposing (SystemDocumentInfo, SystemDocumentLog)


-- type Page
--     = Other
--     | Home
--     | Login
--
-- view : Maybe Viewer -> Page -> { title : String, content : Html msg } -> Document msg


type ViewInfo
    = VI_None
    | VI_System SystemDocumentInfo
    | VI_SystemLogs SystemDocumentInfo SystemDocumentLog
