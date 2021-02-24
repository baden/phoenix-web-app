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
import Html.Attributes as HA exposing (alt, attribute, class, classList, href, id, src, style, type_, value)
import Html.Events as HE exposing (onClick)
import MD5 exposing (hex)
import Msg as GMsg


type alias Model =
    { username : String
    , password : String
    , passwordConfirm : String
    , menuModel : Menu.Model
    }


type Msg
    = OnName String
    | OnPassword String
    | Update Model
    | Auth
    | Register
    | MenuMsg Menu.Msg


init : ( Model, Cmd Msg )
init =
    ( Model "" "" "" Menu.init, Cmd.none )


update : Msg -> Model -> ( Model, Cmd Msg, Maybe GMsg.UpMsg )
update msg model =
    case msg of
        OnName val ->
            ( { model | username = val }, Cmd.none, Nothing )

        OnPassword val ->
            ( { model | password = val }, Cmd.none, Nothing )

        Update newModel ->
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


loginView : AppState -> Model -> Html Msg
loginView ({ t } as appState) model =
    div [ class "container container-login" ]
        [ div [ class "wrapper-content" ]
            [ div [ class "wrapper-bg" ]
                [ div [ class "logo logo-wr" ]
                    [ img [ alt "Logo", src "images/logo.svg" ] [] ]
                , div [ class "login-title" ] [ text <| t "login.Добро пожаловать" ]
                , div [ class "login-subtitle" ] [ text <| t "login.Войдите, чтобы продолжить" ]
                , div [ class "login-inputs" ]
                    [ div [ class "input-st input-errored" ]
                        [ input [ type_ "text", attribute "required" "", value model.username, HE.onInput (\new -> Update { model | username = new }) ]
                            []
                        , label [ class "input-label" ] [ text <| t "login.Введите Ваш логин" ]

                        -- , span [ class "input-error" ] [ span [ class "error-icon" ] [], text <| t "login.name_not_found" ]
                        ]
                    , div [ class "input-st password" ]
                        [ input [ id "password", attribute "required" "", type_ "password", value model.password, HE.onInput (\new -> Update { model | password = new }) ] []
                        , label [ class "input-label" ] [ text <| t "login.Введите Ваш пароль" ]
                        , span [ class "password-icon", id "passwordBtn" ] []
                        , span [ class "input-error" ]
                            [ span [ class "error-icon" ] [], text <| t "login.Неправильный пароль" ]
                        ]
                    , button [ class "btn btn-lg btn-primary login-btn", onClick Auth ] [ text <| t "login.Войти в систему" ]
                    , span [ class "accaunt-link" ]
                        [ span [] [ text <| t "login.У вас нет аккаунта?" ], a [ class "link", href "/auth" ] [ text <| t "login.Зарегистрироваться" ] ]
                    ]
                ]
            , div [ class "wrapper-content-footer" ]
                [ Menu.menuLanguage appState model.menuModel |> Html.map MenuMsg
                , Menu.menuTheme appState model.menuModel |> Html.map MenuMsg
                ]
            ]
        ]


loginViewOld : Model -> Html Msg
loginViewOld model =
    UI.smallForm
        [ UI.formHeader "Добро пожаловать"
        , UI.formSubtitle "Войдите, чтобы продолжить"
        , UI.formLogin
            [ UI.formInput "Имя пользователя" model.username (\new -> Update { model | username = new })
            , UI.formPassword "Пароль" model.password (\new -> Update { model | password = new })
            , UI.formButton "Войти в систему" Nothing (Just Auth)
            , UI.loginSecondary "У вас нет аккаунта?"
            , UI.greenLink "/auth" "Зарегистрироваться"
            , UI.greenLink2 "#" "Забыли пароль?"
            ]

        -- , UI.formButton ("Войти как " ++ model.username) Nothing (Just Auth)
        -- , UI.button "/auth" "Новый пользователь"
        ]


authView : AppState -> Model -> Html Msg
authView { t } model =
    UI.smallForm
        [ UI.formHeader "Создать аккаунт"
        , UI.formSubtitle "Чтобы начать работать"
        , UI.formLogin
            [ UI.formInput "Введите Ваш логин" model.username (\new -> Update { model | username = new })
            , UI.formPassword "Введите Ваш пароль" model.password (\new -> Update { model | password = new })
            , UI.formPassword "Повторите Ваш пароль" model.passwordConfirm (\new -> Update { model | passwordConfirm = new })
            , UI.eula
            , UI.formButton ("Зарегистрировать пользователя " ++ model.username) (checker model) (Just Register)
            , UI.loginSecondary "Уже есть аккаунт?"
            , UI.greenLink "/login" "Войти в систему"
            ]
        ]



-- Private


checker : Model -> Maybe String
checker model =
    if model.username == "" then
        Just "Введите имя пользователя"

    else if model.password == "" then
        Just "Укажите пароль"

    else if model.password /= model.passwordConfirm then
        Just "Укажите пароль повторно"

    else
        Nothing
