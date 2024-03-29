port module Components.UI.Menu exposing (..)

import API.Account as Account exposing (AccountDocumentInfo)
import API.System as System exposing (State(..), SystemDocumentInfo)
import AppState exposing (AppState)
import AssocList as Dict exposing (Dict)
import Components.UI.Scale as Scale
import Components.UI.Theme as Theme
import Html exposing (Html, a, button, div, img, li, span, text, ul)
import Html.Attributes as HA exposing (alt, attribute, class, classList, href, id, src, style)
import Html.Events as HE exposing (onClick)
import I18N
import Json.Decode as Json
import Page.Route exposing (Page)


type alias Model =
    { themePopup : Bool
    , scalePopup : Bool
    , languagePopup : Bool
    , accountPopup : Bool
    , showLogoutModal : Bool
    , menuHiddenMob : Bool
    , menuOpened : Bool
    }


type Msg
    = ShowThemesPopup
    | ShowScalesPopup
    | SelectTheme Theme.ThemeID
    | SelectScale Scale.ScaleID
    | ShowLanguagePopup
    | SelectLanguage String
    | ShowAccountPopup
    | ShowLogoutModal
    | HideLogoutModal
    | HidePopups
    | OnLogout
    | ToggleMobMenu
    | ToggleDeskMenu


type MenuMsg
    = ChangeLanguage String
    | ChangeTheme String
    | ChangeScale String
    | Logout


init : Model
init =
    { themePopup = False
    , scalePopup = False
    , languagePopup = False
    , accountPopup = False
    , showLogoutModal = False
    , menuHiddenMob = True
    , menuOpened = True
    }


update : Msg -> Model -> ( Model, Cmd Msg, Maybe MenuMsg )
update msg model =
    case msg of
        ShowThemesPopup ->
            ( { model | themePopup = True, scalePopup = False, languagePopup = False, showLogoutModal = False }, Cmd.none, Nothing )

        ShowScalesPopup ->
            ( { model | scalePopup = True, themePopup = False, languagePopup = False, showLogoutModal = False }, Cmd.none, Nothing )

        SelectTheme (Theme.ThemeID tid) ->
            ( { model | themePopup = False }, saveTheme tid, Just <| ChangeTheme tid )

        SelectScale (Scale.ScaleID tid) ->
            ( { model | scalePopup = False }, saveScale tid, Just <| ChangeScale tid )

        ShowLanguagePopup ->
            ( { model | languagePopup = True, themePopup = False, scalePopup = False, showLogoutModal = False }, Cmd.none, Nothing )

        SelectLanguage langCode ->
            ( { model | languagePopup = False }, Cmd.batch [ saveLanguage langCode ], Just <| ChangeLanguage langCode )

        ShowAccountPopup ->
            ( { model | accountPopup = True }, Cmd.none, Nothing )

        ShowLogoutModal ->
            ( { model | showLogoutModal = True }, Cmd.none, Nothing )

        HideLogoutModal ->
            ( { model | showLogoutModal = False }, Cmd.none, Nothing )

        HidePopups ->
            ( { model | themePopup = False, scalePopup = False, languagePopup = False, accountPopup = False }, Cmd.none, Nothing )

        OnLogout ->
            ( model, Cmd.none, Just Logout )

        ToggleMobMenu ->
            ( { model | menuHiddenMob = not model.menuHiddenMob }, Cmd.none, Nothing )

        ToggleDeskMenu ->
            ( { model | menuOpened = not model.menuOpened }, Cmd.none, Nothing )


hideMobMenu : Model -> Model
hideMobMenu model =
    { model | menuHiddenMob = True }


view : Page.Route.PageBase -> AccountDocumentInfo -> AppState -> Maybe SystemDocumentInfo -> Model -> List (Html Msg)
view pageBase account ({ t } as appState) msystem ({ themePopup, languagePopup } as model) =
    let
        class4mob =
            classList [ ( "menu-hidden-mob", model.menuHiddenMob ), ( "menu-opened-mob", not model.menuHiddenMob ) ]

        class4desk =
            classList [ ( "menu-opened", model.menuOpened ), ( "menu-hidden", not model.menuOpened ) ]

        popupShow i =
            case i of
                True ->
                    [ style "display" "block" ]

                False ->
                    []

        ( systemSelected, systemMenu ) =
            case msystem of
                Nothing ->
                    ( False, [] )

                Just system ->
                    ( True
                    , [ menuItem ("/map/" ++ system.id) (pageBase == Page.Route.MapBase) "icon-map" "Карта"
                      , menuItem ("/system/" ++ system.id) (pageBase == Page.Route.SystemInfoBase) "icon-manage" "Управление"
                      , menuItemWithSubmenu ("/system/" ++ system.id ++ "/config") (pageBase == Page.Route.SystemConfigBase) "icon-manage" "Настройки"
                      , menuItem ("/system/" ++ system.id ++ "/logs") (pageBase == Page.Route.SystemLogsBase) "icon-calendar" "События"
                      ]
                    )

        menuItem : String -> Bool -> String -> String -> Html Msg
        menuItem url active icon title_ =
            li []
                [ a [ classList [ ( "active", active ) ], href url ]
                    [ span [ class (icon ++ " submenu-icon") ] []
                    , span [ class "submenu-item-title" ] [ text <| t <| "menu." ++ title_ ]
                    ]
                ]

        menuItemWithSubmenu : String -> Bool -> String -> String -> Html Msg
        menuItemWithSubmenu url active icon title_ =
            let
                submenu suburl subtitle subactive =
                    span [ class "submenu-settings-item", classList [ ( "active", subactive ) ] ] [ a [ href suburl ] [ text <| t <| "menu." ++ subtitle ] ]
            in
            li []
                [ a [ class "menu-settings", classList [ ( "active", active ) ], href url ]
                    [ span [ class "icon-settings submenu-icon" ] []
                    , span [ class "submenu-item-title" ] [ text <| t <| "menu." ++ title_ ]
                    ]
                ]

        sicon =
            case msystem of
                Nothing ->
                    "car"

                Just system ->
                    system.icon
    in
    -- menu menu-hidden-mob menu-opened
    -- menu menu-opened-mob menu-opened
    -- menu menu-opened-mob menu-hidden
    [ button [ class "menu-show-btn-mob mobHiddenBtn mobShowBtn", id "showMenuMob", onClick ToggleMobMenu ] []
    , div [ class "menu", class4mob, class4desk ]
        [ div [ class "menu-header" ]
            [ div [ class "logo" ] []

            -- <!-- КНОМПКИ ДЛЯ ЗАКРИТТЯ ВІДКРИТТЯ МЕНЮ десктоп-->
            , button [ class "menu-show-btn hiddenBtn", classList [ ( "showBtn", not model.menuOpened ) ], onClick ToggleDeskMenu ] []
            , button [ class "menu-close-btn hiddenBtn", classList [ ( "showBtn", model.menuOpened ) ], onClick ToggleDeskMenu ] []

            -- , button [ classList [ ( "menu-toggle-btn", True ), ( "visibility", not model.menuVisibility ) ], id "toggleBtn", onClick ToggleMenu ] []
            -- <!-- КНОМПКИ ДЛЯ ЗАКРИТТЯ  МЕНЮ моб версія-->
            -- , button [ class "menu-close-bg closeMenuBg", classList [ ( "hidden", not model.menuVisibility ) ] ] []
            , button [ class "menu-close-btn-mob mobShowBtn mobHiddenBtn", id "closeMenuMob", onClick ToggleMobMenu ] []
            ]
        , div [ class "menu-body scroll" ]
            [ ul [ class "menu-items" ]
                [ menuItem "/" True "list-icon" "Список Фениксов"
                ]
            , div [ class "menu-options-wr" ]
                [ div [ class "menu-options" ]
                    [ span [ class "menu-options-title" ] [ text <| t "menu.Системные опции" ]
                    , menuTheme appState model
                    , menuScale appState model
                    , menuLanguage appState model
                    ]
                , div [ class "menu-options" ]
                    [ span [ class "menu-options-title" ] [ text <| t "menu.Аккаунт" ]
                    , menuAccount account appState model
                    ]
                ]
            , div [ classList [ ( "submenu scroll", True ), ( "submenu-active", systemSelected ) ] ]
                [ span [ class <| "icon-" ++ sicon ++ " submenu-type" ] []
                , div [ class "submenu-header" ]
                    [ a [ class "submenu-back", href "/" ] [ span [ class "arrow" ] [], span [ class "title" ] [ text <| t "Список Фениксов" ] ]
                    , span [ class "submenu-name" ]
                        [ text <|
                            case msystem of
                                Nothing ->
                                    ""

                                Just system ->
                                    system.title
                        ]
                    , span [ class "submenu-status" ]
                        [ div [ class "fenix-status" ]
                            (fenixStatus appState msystem)
                        ]
                    ]
                , ul [ class "submenu-items" ] systemMenu
                ]
            , modal model.showLogoutModal appState
            ]
        ]
    , div [ class "menu-close-bg closeMenuBg", classList [ ( "menu-close-bg-opened", not model.menuHiddenMob ) ] ] []
    ]



-- Private


fenixStatus : AppState -> Maybe SystemDocumentInfo -> List (Html Msg)
fenixStatus { t } msystem =
    case msystem of
        Nothing ->
            []

        Just system ->
            let
                stateText =
                    -- ( stateText, controlWidgets ) =
                    case system.dynamic of
                        Nothing ->
                            "Данные о состоянии еще не получены"

                        Just dynamic ->
                            case dynamic.state of
                                Nothing ->
                                    "идет определение..."

                                Just Off ->
                                    "Феникс выключен."

                                Just Point ->
                                    "Идет определение местоположения..."

                                Just Tracking ->
                                    "Поиск"

                                -- Just Tracking ->
                                -- ++ prolongCmd
                                Just Hidden ->
                                    System.stateAsString Hidden

                                Just state ->
                                    System.stateAsString state
            in
            [ span [ class "status-icon wait-status" ] []
            , span [ class "status" ] [ text <| t <| "control." ++ stateText ]
            -- , span [ class "icon sleep" ] []
            , span [ class "fas icon fa-parking" ] []
            ]


menuTheme : AppState -> Model -> Html Msg
menuTheme { t, themeName } { themePopup } =
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
            , span [ id "selectedTheme" ] [ text <| t <| "themes." ++ themeName ]
            , span [ class "dropdown-icon" ] []
            ]
        , ul [ class "dropdown-list" ] <|
            [ li [ class "title" ] [ text <| t "menu.Тема" ] ]
                ++ (themes |> Dict.toList |> List.map theme_item)
        ]


menuScale : AppState -> Model -> Html Msg
menuScale { t, scaleName } { scalePopup } =
    let
        scales =
            Scale.defaultScales

        scale_item : ( Scale.ScaleID, Scale.ScaleItem ) -> Html Msg
        scale_item ( sid, { name, class_name } ) =
            li [ onClick <| SelectScale sid ]
                [ span [ class "item" ] [ text <| t ("scales." ++ name) ] ]
    in
    activableDropdown scalePopup
        [ div [ class "dropdown-title", onClickStopPropagation ShowScalesPopup ]
            [ span [ class "mode-icon" ] []
            , span [ id "selectedScale" ] [ text <| t <| "scales." ++ scaleName ]
            , span [ class "dropdown-icon" ] []
            ]
        , ul [ class "dropdown-list" ] <|
            [ li [ class "title" ] [ text <| t "menu.Размер" ] ]
                ++ (scales |> Dict.toList |> List.map scale_item)
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


port saveTheme : String -> Cmd msg


port saveScale : String -> Cmd msg
