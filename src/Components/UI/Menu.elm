port module Components.UI.Menu exposing (..)

import API.Account as Account exposing (AccountDocumentInfo)
import AppState exposing (AppState)
import AssocList as Dict exposing (Dict)
import Components.UI.Theme as Theme
import Html exposing (Html, a, button, div, img, li, span, text, ul)
import Html.Attributes as HA exposing (alt, attribute, class, classList, href, id, src, style)
import Html.Events as HE exposing (onClick)
import I18N
import Json.Decode as Json


type alias Model =
    { themePopup : Bool
    , languagePopup : Bool
    , accountPopup : Bool
    , showLogoutModal : Bool
    }


type Msg
    = ShowThemesPopup
    | SelectTheme Theme.ThemeID
    | ShowLanguagePopup
    | SelectLanguage String
    | ShowAccountPopup
    | ShowLogoutModal
    | HideLogoutModal
    | HidePopups
    | OnLogout


type MenuMsg
    = ChangeLanguage String
    | Logout


init : Model
init =
    { themePopup = False
    , languagePopup = False
    , accountPopup = False
    , showLogoutModal = False
    }


update : Msg -> Model -> ( Model, Cmd Msg, Maybe MenuMsg )
update msg model =
    case msg of
        ShowThemesPopup ->
            ( { model | themePopup = True, languagePopup = False, showLogoutModal = False }, Cmd.none, Nothing )

        SelectTheme tid ->
            ( { model | themePopup = False }, Cmd.none, Nothing )

        ShowLanguagePopup ->
            ( { model | languagePopup = True, themePopup = False, showLogoutModal = False }, Cmd.none, Nothing )

        SelectLanguage langCode ->
            ( { model | languagePopup = False }, Cmd.batch [ saveLanguage langCode ], Just <| ChangeLanguage langCode )

        ShowAccountPopup ->
            ( { model | accountPopup = True }, Cmd.none, Nothing )

        ShowLogoutModal ->
            ( { model | showLogoutModal = True }, Cmd.none, Nothing )

        HideLogoutModal ->
            ( { model | showLogoutModal = False }, Cmd.none, Nothing )

        HidePopups ->
            ( { model | themePopup = False, languagePopup = False, accountPopup = False }, Cmd.none, Nothing )

        OnLogout ->
            ( model, Cmd.none, Just Logout )


view : AccountDocumentInfo -> AppState -> Model -> Html Msg
view account ({ t } as appState) ({ themePopup, languagePopup } as model) =
    let
        popupShow i =
            case i of
                True ->
                    [ style "display" "block" ]

                False ->
                    []
    in
    div [ class "menu" ]
        [ div [ class "menu-header" ]
            [ div [ class "logo" ] [ img [ alt "Logo", src "images/logo.svg" ] [] ]
            , button [ class "menu-toggle-btn", id "toggleBtn" ] []
            ]
        , ul [ class "menu-items" ]
            [ li []
                [ a [ class "active", href "#" ]
                    [ span [ class "list-icon menu-icon" ] []
                    , span [ class "menu-item-title" ] [ text <| t "Список Фениксов" ]
                    ]
                ]
            ]
        , div [ class "menu-options-wr" ]
            [ div [ class "menu-options" ]
                [ span [ class "menu-options-title" ] [ text <| t "menu.Системные опции" ]
                , menuTheme appState model
                , menuLanguage appState model
                ]
            , div [ class "menu-options" ]
                [ span [ class "menu-options-title" ] [ text <| t "menu.Аккаунт" ]
                , menuAccount account appState model
                ]
            ]
        , div [ class "submenu" ]
            [ span [ class "icon-car submenu-type" ] []
            , div [ class "submenu-header" ]
                [ a [ class "submenu-back", href "#" ]
                    [ span [ class "arrow" ] []
                    , span [ class "title" ] [ text <| t "Список Фениксов" ]
                    ]
                , span [ class "submenu-name" ] [ text "АА 1234 АС" ]
                , span [ class "submenu-status" ]
                    [ div [ class "fenix-status" ]
                        [ span [ class "status-icon wait-status" ] []
                        , span [ class "status" ] [ text "Ожидание" ]
                        , span [ class "icon sleep" ] []
                        ]
                    ]
                ]
            , ul [ class "submenu-items" ]
                [ li []
                    [ a [ href "#" ]
                        [ span [ class "icon-map submenu-icon" ] []
                        , span [ class "submenu-item-title" ] [ text "Карта" ]
                        ]
                    ]
                , li []
                    [ a [ class "active", href "#" ]
                        [ span [ class "icon-manage submenu-icon" ] []
                        , span [ class "submenu-item-title" ] [ text "Управление" ]
                        ]
                    ]
                , li []
                    [ a [ href "#" ]
                        [ span [ class "icon-settings submenu-icon" ] []
                        , span [ class "submenu-item-title" ] [ text "Настройки" ]
                        ]
                    ]
                , li []
                    [ a [ href "#" ]
                        [ span [ class "icon-calendar submenu-icon" ] []
                        , span [ class "submenu-item-title" ] [ text "События" ]
                        ]
                    ]
                ]
            ]
        , modal model.showLogoutModal appState
        ]



-- Private


menuTheme : AppState -> Model -> Html Msg
menuTheme { t } { themePopup } =
    let
        themes =
            Theme.defaultThemes

        theme_item : ( Theme.ThemeID, Theme.ThemeItem ) -> Html Msg
        theme_item ( tid, { name, class_name } ) =
            li [ onClick <| SelectTheme tid ]
                [ span [ class "item" ] [ text <| t ("themes." ++ name) ] ]
    in
    activableDropdown themePopup
        [ div [ class "dropdown-title", onClickStopPropagation ShowThemesPopup ]
            [ span [ class "mode-icon" ] []
            , span [ id "selectedTheme" ] [ text "Темная" ]
            , span [ class "dropdown-icon" ] []
            ]
        , ul [ class "dropdown-list" ] <|
            [ li [ class "title" ] [ text "Тема" ] ]
                ++ (themes |> Dict.toList |> List.map theme_item)
        ]


menuLanguage : AppState -> Model -> Html Msg
menuLanguage { langCode, t } { languagePopup } =
    let
        languages =
            I18N.languages

        langItem : I18N.LanguageItem -> Html Msg
        langItem l =
            li [ onClick <| SelectLanguage l.langCode ]
                [ span [ class "item" ]
                    [ span [ class <| "flag " ++ l.flag ] [], text l.title ]
                ]
    in
    activableDropdown languagePopup
        [ div [ class "dropdown-title", onClickStopPropagation ShowLanguagePopup ]
            [ span [ class "language-icon" ] []
            , span [ id "selectedLanguage" ] [ text <| .title <| I18N.langCode2lang langCode ]
            , span [ class "dropdown-icon" ] []
            ]
        , ul [ class "dropdown-list" ] <|
            [ li [ class "title" ] [ text <| t "menu.Язык" ] ]
                ++ (languages |> List.map langItem)
        ]


menuAccount : AccountDocumentInfo -> AppState -> Model -> Html Msg
menuAccount account { t } { accountPopup } =
    let
        account_text =
            account.realname
    in
    activableDropdown accountPopup
        [ div [ class "dropdown-title", onClickStopPropagation ShowAccountPopup ]
            [ span [ class "accaunt-icon" ] []
            , span [ class "accaunt-title" ] [ text account_text ]
            , span [ class "dropdown-icon" ] []
            ]
        , ul [ class "dropdown-list" ]
            [ li [ class "title" ] [ text <| t "menu.Аккаунт" ]
            , li [] [ a [ href "#", onClick ShowLogoutModal ] [ span [ class "icon-logout logout-image" ] [], text <| t "menu.Выйти" ] ]
            ]
        ]


modal : Bool -> AppState -> Html Msg
modal show { t } =
    div
        [ class <|
            "modal-bg"
                ++ (if show then
                        " show"

                    else
                        ""
                   )
        ]
        [ div [ class "modal-wr" ]
            [ div [ class "modal-content modal-sm" ]
                [ div [ class "modal-close-sm close modal-close-btn", onClick HideLogoutModal ] []
                , div [ class "modal-title modal-title-sm" ] [ text <| t "menu.Выйти?" ]
                , div [ class "modal-body" ] [ span [ class "modal-text" ] [ text <| t "menu.Вы действительно хотите выйти?" ] ]
                , div [ class "modal-btn-group" ]
                    [ button [ class "btn btn-md btn-secondary modal-close-btn", onClick HideLogoutModal ] [ text <| t "Нет" ]
                    , button [ class "btn btn-md btn-cancel", onClick OnLogout ] [ text <| t "Да" ]
                    ]
                ]
            ]
        ]


activableDropdown : Bool -> List (Html Msg) -> Html Msg
activableDropdown d =
    div [ classList [ ( "dropdown", True ), ( "active", d ) ] ]


onClickStopPropagation : Msg -> Html.Attribute Msg
onClickStopPropagation msg =
    HE.stopPropagationOn "click" <| Json.succeed ( msg, True )


port saveLanguage : String -> Cmd msg
