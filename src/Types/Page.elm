module Types.Page exposing (..)

import API
import API.Account exposing (AccountDocumentInfo, fixSysListRequest)
import API.System exposing (SystemDocumentInfo, SystemDocumentLog, SystemDocumentParams)
import AppState exposing (AppState)
import Components.UI.Menu as Menu
import Components.UI.Theme as Theme
import Dict exposing (Dict)
import Html exposing (Html)
import I18N
import I18Next
import List.Extra as ListExtra
import Msg as MsgT exposing (UpMsg)


type alias PageRec pageModel pageMsg parentModel parentMsg =
    { get : parentModel -> pageModel
    , set : pageModel -> parentModel -> parentModel
    , update : PageUpdateType pageModel pageMsg
    , view : PageType pageModel pageMsg
    , msg : pageMsg -> parentMsg
    }


type PageType pageModel pageMsg
    = PT_System (AppState -> pageModel -> SystemDocumentInfo -> Html pageMsg)
    | PT_SystemParams (AppState -> pageModel -> SystemDocumentInfo -> Maybe SystemDocumentParams -> Html pageMsg)
    | PT_Nodata (AppState -> pageModel -> Html pageMsg)
    | PT_Full (AppState -> pageModel -> Maybe AccountDocumentInfo -> Dict String SystemDocumentInfo -> Html pageMsg)



-- | PT_SysLogs (AppState.AppState -> pageModel -> SystemDocumentInfo -> Maybe (List SystemDocumentLog) -> UI pageMsg)


type PageUpdateType pageModel pageMsg
    = PUT_Private (pageMsg -> pageModel -> ( pageModel, Cmd pageMsg ))
    | PUT_Public (pageMsg -> pageModel -> ( pageModel, Cmd pageMsg, Maybe UpMsg ))



-- updateOverRec msg rec model upmessageUpdate =


updateOverRec msg rec model =
    case rec.update of
        PUT_Private u ->
            let
                ( updatedModel, upstream ) =
                    u msg (rec.get model)
            in
            ( rec.set updatedModel model, upstream |> Cmd.map rec.msg )

        PUT_Public u ->
            let
                ( updatedModel, upstream, upmessage ) =
                    u msg (rec.get model)
            in
            ( rec.set updatedModel model, upstream |> Cmd.map rec.msg )
                |> upmessageUpdate upmessage


type alias Model x =
    { x
        | account : Maybe AccountDocumentInfo
        , appState : AppState
        , tracks : Dict String API.System.SystemDocumentTrack
    }


upmessageUpdate : Maybe UpMsg -> ( Model x, Cmd parentMsg ) -> ( Model x, Cmd parentMsg )
upmessageUpdate msg ( model, cmd ) =
    case msg of
        Nothing ->
            ( model, cmd )

        Just (MsgT.RemoveSystemFromList sid) ->
            case model.account of
                Nothing ->
                    ( model, cmd )

                Just account ->
                    let
                        newSysList =
                            account.systems |> ListExtra.remove sid
                    in
                    -- ( model, Cmd.batch [ cmd, API.websocketOut <| fixSysListRequest newSysList ] )
                    -- TODO: Временно убрал функцию удаления Феникса
                    ( model, Cmd.batch [ cmd ] )

        Just (MsgT.MenuMsg menuMsg) ->
            case menuMsg of
                Menu.ChangeLanguage langCode ->
                    -- let
                    --     t =
                    --         I18Next.t (I18N.translations langCode)
                    --
                    --     tr =
                    --         I18Next.tr (I18N.translations langCode) I18Next.Curly
                    --
                    --     appState =
                    --         model.appState
                    --
                    --     newAppState =
                    --         { appState | langCode = langCode, t = t, tr = tr }
                    -- in
                    -- ( { model | appState = newAppState }, cmd )
                    ( model, cmd ) |> I18N.replaceTranslator langCode

                Menu.ChangeTheme themeName ->
                    ( model, cmd ) |> Theme.replaceTheme themeName

                Menu.Logout ->
                    -- TODO:
                    ( model, cmd )

        Just (MsgT.HideTrack sysId) ->
            ( { model | tracks = Dict.remove sysId model.tracks }, cmd )
