module Page.Login exposing (Model, Msg(..), init, update, loginView, authView)

import Html exposing (Html)


-- import Element exposing (..)
-- import Element.Input as Input
-- import Element.Background as Background
-- import Element.Font as Font
-- import Element.Border as Border

import Components.UI as UI


type alias Model =
    { username : String
    , password : String
    , passwordConfirm : String
    }


type Msg
    = OnName String
    | OnPassword String
    | Update Model


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


loginView : Model -> Html Msg
loginView model =
    UI.smallForm
        [ UI.formHeader "Авторизация"
        , UI.formInput "Имя пользователя" model.username (\new -> Update { model | username = new })
        , UI.formPassword "Пароль" model.password (\new -> Update { model | password = new })
        , UI.formButton ("Авторизоваться как " ++ model.username) (Nothing) Nothing
        ]


authView : Model -> Html Msg
authView model =
    UI.smallForm
        [ UI.formHeader "Регистрация нового пользователя."
        , UI.formInput "Имя пользователя" model.username (\new -> Update { model | username = new })
        , UI.formPassword "Пароль" model.password (\new -> Update { model | password = new })
        , UI.formPassword "Подтвердите пароль" model.passwordConfirm (\new -> Update { model | passwordConfirm = new })
        , UI.formButton ("Зарегистрировать пользователя " ++ model.username) (checker model) Nothing
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
