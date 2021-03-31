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
    }


encodeMarker : Marker -> Encode.Value
encodeMarker { pos, title } =
    Encode.object
        [ ( "pos", encodeLatLng pos )
        , ( "title", Encode.string title )
        ]


decodeMarker : Decode.Decoder Marker
decodeMarker =
    Decode.map2 Marker
        (Decode.field "pos" decodeLatLng)
        (Decode.field "title" Decode.string)
