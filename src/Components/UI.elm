module Components.UI
    exposing
        ( button
        , iconButton
        , cmdButton
        , cmdIconButton
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
        , modal
        , modal_overlay
        , ModalElement(..)
        , title_item
        , smsLink
        , smsCodeInput
        , connectionWidwet
        , header
        , container
        , widget
        )

import Html exposing (Html, h1, h5, div, a, text, i, input)
import Html.Attributes as HA exposing (class, href, placeholder, value, type_, src)
import Html.Events exposing (onInput, onClick)


cmdButton : String -> m -> Html m
cmdButton label cmd =
    Html.button [ class "waves-effect waves-light btn", onClick cmd ]
        [ text label ]


cmdIconButton : String -> m -> Html m
cmdIconButton label cmd =
    Html.button [ class "waves-effect waves-light btn", onClick cmd ]
        [ Html.i [ HA.class ("fas fa-" ++ label) ] [] ]


button : String -> String -> Html a
button url label =
    a [ class "waves-effect waves-light btn", href url ]
        [ text label ]


iconButton : String -> String -> Html a
iconButton label url =
    a [ class "waves-effect waves-light btn", href url ]
        [ Html.i [ HA.class ("fas fa-" ++ label) ] [] ]


formHeader : String -> Html m
formHeader text_title =
    h5 [] [ text text_title ]


formInput : String -> String -> (String -> msg) -> Html msg
formInput text_title value_ update =
    input
        [ onInput update
        , placeholder text_title
        , value value_
        ]
        []


formPassword : String -> String -> (String -> msg) -> Html msg
formPassword text_title value_ update =
    input
        [ type_ "password"
        , onInput update
        , value value_
        , placeholder text_title
        ]
        []


formButton : String -> Maybe String -> Maybe msg -> Html msg
formButton text_title enabled update =
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
                    [ text text_title ]

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
info_2_10 text_title value =
    row
        [ -- Html.div [ class "col s2" ] [ text text_title ]
          Html.div [ class "col s12" ] [ text value ]
        ]


linkButton : String -> String -> Html a
linkButton text_title link_ref =
    Html.a
        [ class "waves-effect waves-light btn"
        , href link_ref
        ]
        [ text text_title ]


text : String -> Html a
text value =
    Html.text value


qr_code : msg -> Html msg
qr_code msg =
    div [ onClick msg ]
        [ Html.img [ src "static/images/fx.navi.cc.png" ] []
        ]


video : Html a
video =
    Html.node "video"
        [ src "http://f-x.com.ua/wp-content/uploads/2019/08/Project-5-convert-video-online.com_.mp4"
        , HA.autoplay True
        , HA.loop False

        -- , HA.muted ""
        -- , HA.playsinline ""
        -- , HA.uk - cover ""
        , HA.class "uk-cover"
        , HA.style "width" "875px"
        , HA.style "height" "492px"
        ]
        []


app_title : Html a
app_title =
    Html.h1 [] [ Html.text "Феникс" ]


header : Bool -> msg -> msg -> List (Html msg)
header showQrCode msg1 msg2 =
    [ div [ HA.style "background-color" "rgba(14,38,67,0.8)" ]
        [ Html.img [ src "static/images/logo.png", HA.style "margin-left" "20px" ] []
        , Html.div [ HA.class "head-control" ]
            [ Html.a [ HA.href "/properties" ] [ Html.i [ HA.class "fas fa-cogs" ] [] ]
            , Html.i [ HA.class "fas fa-qrcode", onClick msg1 ] []
            ]
        ]
    ]
        ++ (if showQrCode then
                [ qr_code msg2 ]
            else
                []
           )


card_panel : List (Html a) -> Html a
card_panel childs =
    Html.div [ class "card-panel" ]
        [ Html.span [ class "blue-text text-darken-2" ] childs
        ]


card : List (Html a) -> Html a
card child =
    Html.div [ class "col s12 m4 l2" ]
        [ Html.div [ class "z-depth-2 shadow-demo" ] child ]


type ModalElement m
    = ModalText String
    | ModalHtml (Html m)


modal : String -> List (ModalElement m) -> List (Html m) -> Html m
modal text_title content buttons =
    let
        element =
            (\row_value ->
                case row_value of
                    ModalText text_value ->
                        Html.p [] [ Html.text text_value ]

                    ModalHtml html ->
                        html
            )
    in
        Html.div
            [ class "modal open"
            , HA.tabindex 0
            , HA.style "z-index" "1003"
            , HA.style "display" "block"
            , HA.style "opacity" "1"
            , HA.style "top" "10%"
            , HA.style "transform" "scaleX(1) scaleY(1)"
            ]
            [ Html.div [ class "modal-content" ] <|
                [ Html.h4 []
                    [ Html.text text_title ]
                ]
                    ++ (content |> List.map element)
            , Html.div [ class "modal-footer" ] buttons
            ]


modal_overlay : m -> Html m
modal_overlay cancelcmd =
    Html.div
        [ class "modal-overlay"
        , HA.style "z-index" "1002"
        , HA.style "display" "block"
        , HA.style "opacity" "0.5"
        , onClick cancelcmd
        ]
        []


title_item : String -> Html a
title_item text_label =
    Html.h4 [] [ text text_label ]


smsLink : String -> String -> Html a
smsLink phone body =
    Html.a [ HA.href <| "sms:" ++ phone ++ "?body=" ++ body ] [ text "Отправить SMS" ]


smsCodeInput : String -> (String -> cmd) -> cmd -> Html cmd
smsCodeInput code_ cmd_ start_ =
    Html.div [ class "row" ]
        [ div [ class "col s6 offset-s3 m4 offset-m4 l2 offset-l5" ]
            ([ Html.input
                [ HA.class "sms_code"
                , HA.placeholder "Введите код из SMS"
                , HA.value code_
                , HA.autofocus True
                , onInput cmd_
                , HA.pattern "[A-Za-z0-9]{3}"
                ]
                []
             ]
                ++ (if code_ /= "" then
                        [ cmdButton "Добавить" start_ ]
                    else
                        []
                   )
            )
        ]


connectionWidwet : List (Html a)
connectionWidwet =
    [ div
        [ class "modal-overlay"
        , HA.style "z-index" "1002"
        , HA.style "display" "block"
        , HA.style "opacity" "0.5"
        ]
        []
    , div [ class "connection", HA.style "z-index" "1003" ]
        [ text "Нет соединения с сервером"
        ]
    ]


container : List (Html a) -> Html a
container =
    div [ class "container" ]


widget : List (Html a) -> Html a
widget child =
    div [ class "row" ]
        [ div [ class "col s12 m8 offset-m2 xl7 offset-xl2" ] child ]
