module I18N exposing (..)

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
