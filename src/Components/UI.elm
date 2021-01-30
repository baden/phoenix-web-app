module Components.UI exposing (..)

-- module Components.UI exposing
--     ( MasterElement(..)
--     , MasterItem
--     , ModalElement(..)
--     , UI
--     , app_title
--     , button
--     , card
--     , card_panel
--     , cmdButton
--     , cmdIconButton
--     , cmdIconButtonR
--     , cmdTextIconButton
--     , cmdTextIconButtonR
--     , column12
--     , connectionWidwet
--     , container
--     , formButton
--     , formHeader
--     , formInput
--     , formInputInline
--     , formPassword
--     , formSubtitle
--     , header
--     , header_expander
--     , iconButton
--     , info_2_10
--     , linkButton
--     , linkIconButton
--     , linkIconTextButton
--     , linkIconTextButtonR
--     , master
--     , modal
--     , modal_overlay
--     , qr_code
--     , row
--     , row_item
--     , smallForm
--     , smsCodeInput
--     , smsLink
--     , stitle
--     , text
--     , title_item
--     , widget
--     )

import Html exposing (Html, a, div, form, h1, h5, i, img, input, span, text)
import Html.Attributes as HA exposing (alt, class, href, placeholder, src, type_, value)
import Html.Events exposing (onClick, onInput)
import Svg exposing (path, svg, text_)
import Svg.Attributes exposing (d, preserveAspectRatio, strokeDasharray, viewBox, x, y)


type alias UI msg =
    Html msg


cmdButton : String -> m -> Html m
cmdButton label cmd =
    Html.button [ class "btn btn-sm blue-btn", onClick cmd ]
        [ text label ]


cmdIconButton : String -> m -> Html m
cmdIconButton label cmd =
    Html.button [ class "btn btn-sm blue-btn", onClick cmd ]
        [ Html.i [ HA.class ("fas fa-" ++ label) ] [] ]


cmdIconButtonR : String -> m -> Html m
cmdIconButtonR label cmd =
    Html.button [ class "btn btn-sm red-btn red", onClick cmd ]
        [ Html.i [ HA.class ("fas fa-" ++ label) ] [] ]


cmdTextIconButton : String -> String -> m -> Html m
cmdTextIconButton icon label cmd =
    Html.button [ class "btn btn-sm blue-btn", onClick cmd ]
        [ Html.i [ HA.class ("left fas fa-" ++ icon) ] [], Html.text label ]


cmdTextIconButtonR : String -> String -> m -> Html m
cmdTextIconButtonR icon label cmd =
    Html.button [ class "btn btn-sm red-btn red", onClick cmd ]
        [ Html.i [ HA.class ("left fas fa-" ++ icon) ] [], Html.text label ]


button : String -> String -> Html a
button url label =
    a [ class "btn btn-sm blue-btn", href url ]
        [ text label ]


iconButton : String -> String -> Html a
iconButton label url =
    a [ class "btn btn-sm blue-btn", href url ]
        [ Html.i [ HA.class ("fas fa-" ++ label) ] [] ]



-- TODO: Rename to formTitle


formHeader : String -> Html m
formHeader text_title =
    -- h5 [] [ text text_title ]
    div [ class "login-title" ] [ text text_title ]


formSubtitle : String -> Html m
formSubtitle text_subtitle =
    div [ class "login-subtitle" ] [ text text_subtitle ]


formInput : String -> String -> (String -> msg) -> Html msg
formInput text_title value_ update =
    div [ class "input-st" ]
        [ input
            [ onInput update
            , placeholder text_title
            , value value_
            ]
            []
        ]


formLogin : List (Html msg) -> Html msg
formLogin =
    form [ class "login-inputs" ]


formInputInline : String -> String -> (String -> msg) -> Html msg
formInputInline text_title value_ update =
    input
        [ onInput update
        , placeholder text_title
        , value value_
        , class "inline"
        ]
        []


formPassword : String -> String -> (String -> msg) -> Html msg
formPassword text_title value_ update =
    div [ class "input-st password" ]
        [ input
            [ type_ "password"
            , onInput update
            , value value_
            , placeholder text_title
            ]
            []
        , span [ class "password-icon" ]
            [ img [ src "static/images/eye.svg", alt "Logo" ] []
            ]
        ]


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
            Html.button
                ([ class "btn blue-btn" ] ++ cmd)
                [ text text_title ]

        Just text_ ->
            Html.span [ class "error" ] [ text text_ ]


loginSecondary : String -> Html a
loginSecondary txt_ =
    a [ href "#", class "accaunt-link-gr accaunt-link" ] [ text txt_ ]


greenLink : String -> String -> Html a
greenLink url_ txt_ =
    a [ href url_, class "accaunt-link-green accaunt-link" ] [ text txt_ ]


eula : Html a
eula =
    span [ class "checkmark-wrap" ]
        [ Html.label [ class "checkboxContainer" ]
            [ input [ type_ "checkbox", value "", HA.name "" ] []
            , span [ class "checkmark" ] []
            ]
        , span [ class "checkmark-text" ]
            [ text "Я прочитал и принимаю условия "
            , a [ href "#" ] [ text "пользовательского соглашения" ]
            ]
        ]


greenLink2 : String -> String -> Html a
greenLink2 url_ txt_ =
    a [ href url_, class "accaunt-link-green accaunt-link mt-20" ] [ text txt_ ]


column12 : List (Html a) -> Html a
column12 childrens =
    div [ class "col s12" ] childrens


appHeader : String -> Html a
appHeader extra =
    div [ class <| "header" ++ extra ]
        [ div [ class "language" ]
            [ span [ class "language-menu" ]
                [ img [ src "static/images/ellipsis.svg", alt "Logo" ] []
                ]
            ]
        , div [ class "logo" ]
            [ img [ src "static/images/logo.svg", alt "Logo" ] []
            ]
        ]


smallForm : List (Html a) -> Html a
smallForm childrens =
    div [ class "container container-logo" ]
        [ appHeader ""
        , div [ class "login-content" ] childrens
        ]


wellcomeContent : List (Html a) -> Html a
wellcomeContent =
    div [ class "login-content welcome-content" ]


wellcomeTitle : String -> Html a
wellcomeTitle title_ =
    div [ class "login-title welcome-title" ] [ text title_ ]


wellcomeButton : String -> Html a
wellcomeButton title_ =
    Html.a [ href "/linksys", class "btn blue-btn btn-add" ] [ text title_ ]


type alias MasterItem m =
    { title : String
    , content : List (MasterElement m)
    }


type MasterElement m
    = MasterElementText String
    | MasterElementSMSLink
      -- | MasterElementHelp String m String
    | MasterElementCmdButton String m
    | MasterElementTextField String (String -> m) m
    | MasterElementNext m
    | MasterElementPrev m


master : List (MasterItem m) -> Html m
master ch =
    div [ class "row" ]
        (ch
            |> List.foldl (\e acc -> acc ++ [ master_element e ]) []
        )


master_element : MasterItem m -> Html m
master_element { title, content } =
    let
        melem e =
            case e of
                MasterElementText val ->
                    -- div [ class "row" ] [ div [ class "col s12" ] [ text val ] ]
                    --
                    Html.li [] [ text val ]

                MasterElementSMSLink ->
                    smsLink "" "link"

                MasterElementCmdButton mtitle mcmd ->
                    -- Html.div [ HA.class "row" ] [ cmdButton mtitle mcmd ]
                    -- cmdButton mtitle mcmd
                    Html.button [ class "btn btn-sm blue-btn", onClick mcmd ] [ text mtitle ]

                MasterElementTextField mcode mOnCode mStartLink ->
                    smsCodeInput mcode mOnCode mStartLink

                MasterElementNext mOnNext ->
                    -- cmdTextIconButton "arrow-right"
                    --     "Далее"
                    --     mOnNext
                    Html.button [ class "btn btn-sm blue-btn btn-next", onClick mOnNext ] [ text "Далее" ]

                MasterElementPrev mOnPrev ->
                    -- cmdTextIconButton "arrow-left" "Назад" mOnPrev
                    Html.button [ class "btn btn-sm dark-btn btn-prev", onClick mOnPrev ] [ text "Назад" ]
    in
    div []
        [ Html.div [ class "title-st" ] [ text title ]

        -- <ol class="list-numbered list">
        , Html.ol [ class "list-numbered list" ]
            (content
                |> List.map melem
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
        [ class "btn blue-btn", href link_ref ]
        [ text text_title ]


linkIconButton : String -> String -> Html a
linkIconButton icon link_ref =
    Html.a
        [ class "btn blue-btn", href link_ref ]
        [ Html.i [ HA.class ("left fas fa-" ++ icon) ] [] ]


linkIconTextButton : String -> String -> String -> Html a
linkIconTextButton icon text_title link_ref =
    Html.a
        [ class "btn blue-btn", href link_ref ]
        [ Html.i [ HA.class ("left fas fa-" ++ icon) ] [], text text_title ]


linkIconTextButtonR : String -> String -> String -> Html a
linkIconTextButtonR icon text_title link_ref =
    Html.a
        [ class "btn red-btn red", href link_ref ]
        [ Html.i [ HA.class ("left far fa-" ++ icon) ] [], text text_title ]


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
    Html.div [ class "fenix fenix-bg fenix-taxi" ] child


cardHeader : String -> String -> Html a
cardHeader state_text config_link =
    div [ class "fenix-header" ]
        [ div [ class "status" ]
            [ Html.button [ class "btn-wait orange-btn" ] [ Html.text state_text ]
            , img [ src "static/images/green-car.svg", alt "car-green" ] []
            ]
        , Html.a [ class "fenix-set-btn", href config_link ] []
        ]


cardBody : List (Html a) -> Html a
cardBody =
    div [ class "fenix-body" ]


cardTitle : String -> Html a
cardTitle ttle =
    div [ class "fenix-title" ] [ text ttle ]


cardPwrPanel : Html a
cardPwrPanel =
    div [ class "fenix-power-wr" ]
        [ span [ class "power" ]
            [ span [ class "power-top" ] []
            , span [ class "power-wr" ]
                [ -- changing height for this block and add class low for change  power
                  span [ class "power-bg full", HA.style "height" "80%" ]
                    [ svg [ viewBox "0 0 500 500", preserveAspectRatio "xMinYMin meet" ]
                        [ path [ d "M0, 100 C150, 200 350, 0 500, 100 L500, 00 L0, 0 Z", Svg.Attributes.style "stroke:none; fill: #323343;" ] []
                        ]
                    ]
                ]
            ]
        , span [ class "text" ]
            [ text "В режиме Ожидания:"
            , Html.br [] []
            , text "8 месяцев 17 дней"
            ]
        ]


cardFooter : String -> Maybe String -> Html a
cardFooter control_link m_map_link =
    let
        map_key =
            case m_map_link of
                Nothing ->
                    Html.a [ class "btn btn-sm dark-btn disabled" ] [ text "На карте" ]

                Just map_link ->
                    Html.a [ class "btn btn-sm blue-btn", href map_link ] [ f_icon "map", text " ", text "На карте" ]
    in
    div [ class "fenix-footer" ]
        [ map_key
        , Html.a [ class "btn btn-sm blue-btn", href control_link ] [ f_icon "gamepad", text " ", text "Управление" ]
        ]


f_icon : String -> Html a
f_icon icon =
    Html.i [ HA.class ("left fas fa-" ++ icon) ] []



-- [ Html.div [ class "z-depth-2 shadow-demo scard" ] child ]


type ModalElement m
    = ModalText String
    | ModalHtml (Html m)
    | ModalIconText String String


modal : String -> List (ModalElement m) -> List (Html m) -> Html m
modal text_title content buttons =
    let
        element =
            \row_value ->
                case row_value of
                    ModalText text_value ->
                        Html.p [] [ Html.text text_value ]

                    ModalIconText icon text_value ->
                        Html.p [] [ Html.img [ HA.style "margin" "-3px 10px -3px 0", src <| "static/" ++ icon ] [], Html.text text_value ]

                    -- ModalIconText icon text_value ->
                    --     Html.p [] [ Html.div [ HA.class "led_flash led_fast_flash" ] [], Html.text text_value ]
                    ModalHtml html ->
                        html
    in
    Html.div
        [ class "modal open left-align"
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
    Html.div [ class "title-sm-gr hide-on-small-and-down" ] [ text text_label ]


smsLink : String -> String -> Html a
smsLink phone body =
    Html.a [ class "input-label", HA.href <| "sms:" ++ phone ++ "?body=" ++ body ] [ text "Отправить SMS" ]


smsCodeInput : String -> (String -> cmd) -> cmd -> Html cmd
smsCodeInput code_ cmd_ start_ =
    Html.div [ class "input-st" ]
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
    div [ class "container container-logo" ]


widget : List (Html a) -> Html a
widget child =
    div [ class "row" ]
        [ div [ class "col s12 m8 offset-m2 xl7 offset-xl2" ] child ]


stitle : String -> Html a
stitle t =
    Html.span [ HA.class "title" ] [ text t ]


header_expander : UI a
header_expander =
    Html.div [ class "header_expander" ] []


systemList : List (Html a) -> Html a
systemList =
    div [ class "fenix-list" ]


systemListTitle : String -> Html a
systemListTitle ttl_ =
    div [ class "title-st fs-30" ] [ text ttl_ ]


grayLinkButton : String -> String -> Html a
grayLinkButton label_ url_ =
    Html.a [ class "btn btn-sm gray-btn", href url_ ] [ text label_ ]


div_ : List (Html a) -> Html a
div_ =
    Html.div [ class "content-wr" ]
