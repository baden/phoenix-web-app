module Types.Page exposing (..)

import API
import API.Account exposing (AccountDocumentInfo, fixSysListRequest)
import API.System exposing (SystemDocumentInfo, SystemDocumentLog, SystemDocumentParams)
import AppState exposing (AppState)
import Dict exposing (Dict)
import Html exposing (Html)
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
    | PT_Nodata (pageModel -> Html pageMsg)
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
    { x | account : Maybe AccountDocumentInfo }


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
                    ( model, Cmd.batch [ cmd, API.websocketOut <| fixSysListRequest newSysList ] )
