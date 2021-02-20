module I18N exposing (..)

import I18N.En
import I18N.Ru
import I18N.Ua
import I18Next exposing (t)


translations : String -> I18Next.Translations
translations lang =
    case lang of
        "UA" ->
            I18N.Ua.translations

        "EN" ->
            I18N.En.translations

        "RU" ->
            I18N.Ru.translations

        _ ->
            I18N.En.translations



-- import Url.Builder as UrlBuilder
-- TBD
-- langUrl : String -> String
-- langUrl langCode =
--     UrlBuilder.absolute
--         [ "translations"
--         , langCode
--         ]
