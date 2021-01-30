module Page.Login exposing (Model, Msg(..), authView, init, loginView, update)

-- import Element exposing (..)
-- import Element.Input as Input
-- import Element.Background as Background
-- import Element.Font as Font
-- import Element.Border as Border

import API exposing (registerUserRequest)
import Components.UI as UI
import Html exposing (Html)
import MD5 exposing (hex)


type alias Model =
    { username : String
    , password : String
    , passwordConfirm : String
    }


type Msg
    = OnName String
    | OnPassword String
    | Update Model
    | Auth
    | Register


init : ( Model, Cmd Msg )
init =
    ( Model "" "" "", Cmd.none )


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    case msg of
        OnName val ->
            ( { model | username = val }, Cmd.none )

        OnPassword val ->
            ( { model | password = val }, Cmd.none )

        Update newModel ->
            ( newModel, Cmd.none )

        Auth ->
            let
                password_hash =
                    hex model.password
            in
            ( model
            , Cmd.batch
                [ API.websocketOut <|
                    API.authUserRequest model.username password_hash
                ]
            )

        Register ->
            let
                password_hash =
                    hex model.password
            in
            ( model
            , Cmd.batch
                [ API.websocketOut <|
                    API.registerUserRequest model.username password_hash
                ]
            )


loginView : Model -> Html Msg
loginView model =
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


authView : Model -> Html Msg
authView model =
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
