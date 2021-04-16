module Page.Login exposing (Model, Msg(..), authView, init, loginView, update)

-- import Element exposing (..)
-- import Element.Input as Input
-- import Element.Background as Background
-- import Element.Font as Font
-- import Element.Border as Border

import API exposing (registerUserRequest)
import AppState exposing (AppState)
import Components.UI as UI
import Components.UI.Menu as Menu
import Html exposing (Html, a, button, div, img, input, label, li, span, text, ul)
import Html.Attributes as HA exposing (alt, attribute, class, classList, disabled, href, id, name, src, style, type_, value)
import Html.Events as HE exposing (onClick, onInput)
import MD5 exposing (hex)
import Msg as GMsg


type alias Model =
    { username : String
    , password : String
    , passwordConfirm : String
    , menuModel : Menu.Model
    , showPassword : Bool
    , eula : Bool
    }


type Msg
    = OnName String
    | OnPassword String
    | Update Model
    | Auth
    | Register
    | MenuMsg Menu.Msg
    | ShowPassword
    | OnEula Bool


init : ( Model, Cmd Msg )
init =
    ( Model "" "" "" Menu.init False False, Cmd.none )


update : Msg -> Model -> ( Model, Cmd Msg, Maybe GMsg.UpMsg )
update msg model =
    case msg of
        OnName val ->
            ( { model | username = val }, Cmd.none, Nothing )

        OnPassword val ->
            ( { model | password = val }, Cmd.none, Nothing )

        Update newModel ->
            -- TODO: Надо бы переделать. Некрасиво брать модель из view
            ( newModel, Cmd.none, Nothing )

        Auth ->
            let
                password_hash =
                    hex model.password
            in
            ( model
            , Cmd.batch [ API.websocketOut <| API.authUserRequest model.username password_hash ]
            , Nothing
            )

        Register ->
            let
                password_hash =
                    hex model.password
            in
            ( model
            , Cmd.batch [ API.websocketOut <| API.registerUserRequest model.username password_hash ]
            , Nothing
            )

        MenuMsg menuMsg ->
            -- TODO: Не очень мне нравится что меню нужно пробрасывать везде.
            let
                -- _ =
                --     Debug.log "menuMsg" menuMsg
                ( updatedMenuModel, upstream, upmessage ) =
                    Menu.update menuMsg model.menuModel
            in
            -- Menu.Msg
            case upmessage of
                Nothing ->
                    ( { model | menuModel = updatedMenuModel }, upstream |> Cmd.map MenuMsg, Nothing )

                Just upMsg ->
                    ( { model | menuModel = updatedMenuModel }, upstream |> Cmd.map MenuMsg, Just (GMsg.MenuMsg upMsg) )

        ShowPassword ->
            ( { model | showPassword = not model.showPassword }, Cmd.none, Nothing )

        OnEula v ->
            ( { model | eula = v }, Cmd.none, Nothing )


loginView : AppState -> Model -> Html Msg
loginView ({ t } as appState) model =
    div [ class "container container-login" ]
        [ div [ class "wrapper-content" ]
            [ div [ class "wrapper-bg" ]
                [ div [ class "logo logo-wr" ] [ img [ alt "Logo", src "images/logo.svg" ] [] ]
                , div [ class "login-title" ] [ text <| t "login.Добро пожаловать" ]
                , div [ class "login-subtitle" ] [ text <| t "login.Войдите, чтобы продолжить" ]
                , div [ class "login-inputs" ]
                    [ div [ class "input-st" ]
                        [ input [ type_ "text", attribute "required" "", attribute "autofocus" "", value model.username, onInput (\new -> Update { model | username = new }) ] []
                        , label [ class "input-label" ] [ text <| t "login.Введите Ваш логин" ]

                        -- , span [ class "input-error" ] [ span [ class "error-icon" ] [], text <| t "login.name_not_found" ]
                        ]
                    , div [ class "input-st password" ]
                        [ input [ id "password", attribute "required" "", type_ <| password_type model.showPassword, value model.password, onInput (\new -> Update { model | password = new }) ] []
                        , label [ class "input-label" ] [ text <| t "login.Введите Ваш пароль" ]
                        , span [ class <| "password-icon" ++ active_if model.showPassword, id "passwordBtn", onClick ShowPassword ] []
                        , span [ class "input-error" ] [ span [ class "error-icon" ] [], text <| t "login.Неправильный пароль" ]
                        ]
                    , button [ class "btn btn-lg btn-primary login-btn", onClick Auth ] [ text <| t "login.Войти в систему" ]
                    , span [ class "accaunt-link" ] [ span [] [ text <| t "login.У вас нет аккаунта?" ], a [ class "link", href "/auth" ] [ text <| t "login.Зарегистрироваться" ] ]
                    ]
                ]
            , div [ class "wrapper-content-footer" ]
                [ Menu.menuLanguage appState model.menuModel |> Html.map MenuMsg
                , Menu.menuTheme appState model.menuModel |> Html.map MenuMsg
                , Menu.menuScale appState model.menuModel |> Html.map MenuMsg
                ]
            ]
        ]


authView : AppState -> Model -> Html Msg
authView ({ t } as appState) model =
    div [ class "container container-login" ]
        [ div [ class "wrapper-content" ]
            [ div [ class "wrapper-bg" ]
                [ div [ class "logo logo-wr" ] [ img [ alt "Logo", src "images/logo.svg" ] [] ]
                , div [ class "login-title" ] [ text <| t "login.Создать аккаунт" ]
                , div [ class "login-subtitle" ] [ text <| t "login.Чтобы начать работать" ]
                , div [ class "login-inputs" ]
                    [ div [ class "input-st" ]
                        [ input [ attribute "autocomplete" "off", attribute "required" "", type_ "text", value model.username, onInput (\new -> Update { model | username = new }) ] []
                        , label [ class "input-label" ] [ text <| t "login.Введите Ваш логин" ]

                        -- , span [ class "input-error" ] [ span [ class "error-icon" ] [], text "Адрес электронной почты недействителен. Пожалуйста проверьте и попробуйте снова." ]
                        ]
                    , div [ class "input-st password" ]
                        [ input [ attribute "autocomplete" "off", id "password", attribute "required" "", type_ <| password_type model.showPassword, value model.password, onInput (\new -> Update { model | password = new }) ] []
                        , label [ class "input-label" ] [ text <| t "login.Введите Ваш пароль" ]
                        , span [ class <| "password-icon" ++ active_if model.showPassword, id "passwordBtn", onClick ShowPassword ] []

                        -- , span [ class "input-error" ] [ span [ class "error-icon" ] [], text <| "login.Неправильный пароль" ]
                        ]
                    , div [ class "input-st password" ]
                        [ input [ attribute "autocomplete" "off", id "password", attribute "required" "", type_ <| password_type model.showPassword, value model.passwordConfirm, onInput (\new -> Update { model | passwordConfirm = new }) ] []
                        , label [ class "input-label" ] [ text <| t "login.Повторите Ваш пароль" ]
                        , span [ class <| "password-icon" ++ active_if model.showPassword, id "passwordBtn", onClick ShowPassword ] []

                        -- , span [ class "input-error" ] [ span [ class "error-icon" ] [], text <| "login.Неправильный пароль" ]
                        ]
                    , span [ class "checkmark-wrap" ]
                        [ label [ class "checkboxContainer" ] [ input [ name "", type_ "checkbox", value "", HA.checked model.eula, HE.onCheck OnEula ] [], span [ class "checkmark" ] [] ]
                        , span [ class "checkmark-text" ]
                            [ text <| t "login.Я прочитал и принимаю условия", text " ", a [ href "#" ] [ text <| t "login.пользовательского соглашения" ] ]
                        ]

                    -- , button [ class "btn btn-lg btn-primary login-btn", onClick Register ] [ text <| t "login.Зарегистрироваться" ]
                    , registerButton appState model
                    , span [ class "accaunt-link" ] [ span [] [ text <| t "login.Уже есть аккаунт?" ], a [ class "link", href "/login" ] [ text <| t "login.Войти в систему" ] ]
                    ]
                ]
            , div [ class "wrapper-content-footer" ]
                [ Menu.menuLanguage appState model.menuModel |> Html.map MenuMsg
                , Menu.menuTheme appState model.menuModel |> Html.map MenuMsg
                ]
            ]
        ]


registerButton : AppState -> Model -> Html Msg
registerButton { t } model =
    if model.username == "" then
        button [ class "btn btn-lg btn-primary login-btn", disabled True ] [ text <| t "login.Введите имя пользователя" ]
        -- span [ class "input-error d-flex" ] [ span [ class "error-icon" ] [], text <| t "login.Введите имя пользователя" ]

    else if model.password == "" then
        button [ class "btn btn-lg btn-primary login-btn", disabled True ] [ text <| t "login.Укажите пароль" ]
        -- span [ class "input-error d-flex" ] [ span [ class "error-icon" ] [], text <| t "login.Укажите пароль" ]

    else if model.passwordConfirm == "" then
        button [ class "btn btn-lg btn-primary login-btn", disabled True ] [ text <| t "login.Укажите пароль повторно" ]
        -- span [ class "input-error d-flex" ] [ span [ class "error-icon" ] [], text <| t "login.Укажите пароль повторно" ]

    else if model.password /= model.passwordConfirm then
        button [ class "btn btn-lg btn-primary login-btn", disabled True ] [ text <| t "login.Пароль указан неверно" ]
        -- span [ class "input-error d-flex" ] [ span [ class "error-icon" ] [], text <| t "login.Пароль указан неверно" ]

    else if model.eula == False then
        button [ class "btn btn-lg btn-primary login-btn", disabled True ] [ text <| t "login.Вы должны принять условия" ]
        -- span [ class "input-error d-flex" ] [ span [ class "error-icon" ] [], text <| t "login.Пароль указан неверно" ]

    else
        button [ class "btn btn-lg btn-primary login-btn", onClick Register ] [ text <| t "login.Зарегистрироваться" ]



-- authViewOld : AppState -> Model -> Html Msg
-- authViewOld { t } model =
--     UI.smallForm
--         [ UI.formHeader "Создать аккаунт"
--         , UI.formSubtitle "Чтобы начать работать"
--         , UI.formLogin
--             [ UI.formInput "Введите Ваш логин" model.username (\new -> Update { model | username = new })
--             , UI.formPassword "Введите Ваш пароль" model.password (\new -> Update { model | password = new })
--             , UI.formPassword "Повторите Ваш пароль" model.passwordConfirm (\new -> Update { model | passwordConfirm = new })
--             , UI.eula
--             , UI.formButton ("Зарегистрировать пользователя " ++ model.username) (checker model) (Just Register)
--             , UI.loginSecondary "Уже есть аккаунт?"
--             , UI.greenLink "/login" "Войти в систему"
--             ]
--         ]
-- Private


password_type : Bool -> String
password_type enabled =
    -- password_type model.showPassword
    case enabled of
        True ->
            "text"

        False ->
            "password"


active_if : Bool -> String
active_if active =
    case active of
        True ->
            " active"

        False ->
            ""
