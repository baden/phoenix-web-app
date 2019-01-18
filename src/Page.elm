module Page exposing (Page(..), view, viewErrors)


type Page
    = Other
    | Home
    | Login


view : Maybe Viewer -> Page -> { title : String, content : Html msg } -> Document msg
