module Page.Map.Types exposing (..)

import Json.Decode as Decode
import Json.Encode as Encode


type alias LatLng =
    { lat : Float
    , lng : Float
    }


encodeLatLng : LatLng -> Encode.Value
encodeLatLng { lat, lng } =
    -- Encode.list Encode.float [ lat, lon ]
    Encode.object
        [ ( "lat", Encode.float lat )
        , ( "lng", Encode.float lng )
        ]


decodeLatLng : Decode.Decoder LatLng
decodeLatLng =
    Decode.map2 LatLng
        (Decode.field "lat" Decode.float)
        (Decode.field "lng" Decode.float)


type alias Marker =
    { pos : LatLng
    , title : String
    , icon : String
    }


encodeMarker : Marker -> Encode.Value
encodeMarker { pos, title, icon } =
    Encode.object
        [ ( "pos", encodeLatLng pos )
        , ( "title", Encode.string title )
        , ( "icon", Encode.string icon )
        ]


decodeMarker : Decode.Decoder Marker
decodeMarker =
    Decode.map3 Marker
        (Decode.field "pos" decodeLatLng)
        (Decode.field "title" Decode.string)
        (Decode.field "icon" Decode.string)
