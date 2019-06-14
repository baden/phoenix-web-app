module Components.UI
    exposing
        ( button
        , cmdButton
        , formHeader
        , formInput
        , formPassword
        , formButton
        , column12
        , smallForm
        , master
        , MasterItem
        , row
        , row_item
        , info_2_10
        , linkButton
        , text
        , qr_code
        , app_title
        , card_panel
        , card
        )

import Html exposing (Html, h1, h5, div, a, text, i, input)
import Html.Attributes exposing (class, href, placeholder, value, type_, src)
import Html.Events exposing (onInput, onClick)


cmdButton : String -> Html a
cmdButton label =
    Html.button [ class "waves-effect waves-light btn" ]
        [ text label ]


button : String -> String -> Html a
button url label =
    a [ class "waves-effect waves-light btn", href url ]
        [ text label ]


formHeader : String -> Html m
formHeader title =
    h5 [] [ text title ]


formInput : String -> String -> (String -> msg) -> Html msg
formInput title value_ update =
    input
        [ onInput update
        , placeholder title
        , value value_
        ]
        []


formPassword : String -> String -> (String -> msg) -> Html msg
formPassword title value_ update =
    input
        [ type_ "password"
        , onInput update
        , value value_
        , placeholder title
        ]
        []


formButton : String -> Maybe String -> Maybe msg -> Html msg
formButton title enabled update =
    case enabled of
        Nothing ->
            let
                cmd =
                    case update of
                        Nothing ->
                            []

                        Just command ->
                            [ onClick command ]
            in
                a
                    ([ class "waves-effect waves-light btn", href "" ] ++ cmd)
                    [ text title ]

        Just text_ ->
            text text_


column12 : List (Html a) -> Html a
column12 childrens =
    div [ class "col s12" ] childrens


smallForm : List (Html a) -> Html a
smallForm childrens =
    div [ class "row" ]
        [ div [ class "col s8 offset-s2" ] childrens
        ]


type alias MasterItem =
    { title : String
    , content : List String
    }


master : List MasterItem -> Html a
master ch =
    div [ class "row" ]
        [ div [ class "col s8 offset-s2" ]
            (ch
                |> List.foldl (\e acc -> acc ++ [ master_element e ]) []
            )
        ]


master_element : MasterItem -> Html a
master_element { title, content } =
    div []
        [ Html.h5 [] [ text title ]
        , div []
            (content
                |> List.map (\e -> Html.p [] [ text e ])
            )
        ]


row : List (Html a) -> Html a
row child_list =
    Html.div [ class "row" ] child_list


row_item : List (Html a) -> Html a
row_item child =
    row [ Html.div [ class "col s12 " ] child ]


info_2_10 : String -> String -> Html a
info_2_10 title value =
    row
        [ Html.div [ class "col s2" ] [ text title ]
        , Html.div [ class "col s10" ] [ text value ]
        ]


linkButton : String -> String -> Html a
linkButton title link_ref =
    Html.a
        [ class "waves-effect waves-light btn"
        , href link_ref
        ]
        [ text title ]


text : String -> Html a
text value =
    Html.text value


qr_code : Html a
qr_code =
    Html.img [ src "static/images/fx.navi.cc.png", class "nomobile" ] []


app_title : Html a
app_title =
    Html.h1 [] [ Html.text "Феникс" ]


card_panel : List (Html a) -> Html a
card_panel childs =
    Html.div [ class "card-panel" ]
        [ Html.span [ class "blue-text text-darken-2" ] childs
        ]


card : List (Html a) -> Html a
card child =
    Html.div [ class "col s12 m4 l2" ]
        [ Html.div [ class "z-depth-2 shadow-demo" ] child ]
