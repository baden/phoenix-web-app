module I18N exposing (..)

-- import AppState exposing (AppState)
-- import API.Account exposing (AccountDocumentInfo)

import I18N.En
import I18N.Ru
import I18N.Ua
import I18Next exposing (t)
import String


translations : String -> I18Next.Translations
translations lang =
    case lang |> String.toUpper |> String.left 2 of
        "UA" ->
            I18N.Ua.translations

        "EN" ->
            I18N.En.translations

        "RU" ->
            I18N.Ru.translations

        _ ->
            I18N.En.translations


type alias LanguageItem =
    { langCode : String
    , title : String
    , flag : String
    }


languages : List LanguageItem
languages =
    [ LanguageItem "UA" "Українська" "uk"
    , LanguageItem "RU" "Русский" "ru"
    , LanguageItem "EN" "English" "en"
    ]


langCode2lang : String -> LanguageItem
langCode2lang langCode =
    languages
        |> List.filter (\i -> i.langCode == langCode)
        |> List.head
        |> Maybe.withDefault (LanguageItem "RU" "Русский" "ru")



-- import Url.Builder as UrlBuilder
-- TBD
-- langUrl : String -> String
-- langUrl langCode =
--     UrlBuilder.absolute
--         [ "translations"
--         , langCode
--         ]
-- TODO:  Не самое элегантное решение
-- type alias AppState a =
--     { a
--         | langCode : String
--         , t : String -> String
--         , tr : String -> I18Next.Replacements -> String
--     }
--
--
-- type alias Model m =
--     { m | appState : AppState m }
-- type alias Model x =
--     { x
--         | account : Maybe AccountDocumentInfo
--         , appState :
--             { x
--                 | account : Maybe AccountDocumentInfo
--                 , langCode : String
--                 , t : String -> String
--                 , tr : String -> I18Next.Replacements -> String
--             }
--     }
--
--
-- replaceTranslator : String -> ( Model mdl, Cmd msg ) -> ( Model mdl, Cmd msg )


replaceTranslator langCode ( model, cmd ) =
    -- TODO: Type it.
    let
        t =
            I18Next.t (translations langCode)

        tr =
            I18Next.tr (translations langCode) I18Next.Curly

        appState =
            model.appState

        newAppState =
            { appState | langCode = langCode, t = t, tr = tr }
    in
    ( { model | appState = newAppState }, cmd )
