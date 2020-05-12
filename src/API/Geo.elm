module API.Geo exposing (..)

import Http
import Json.Encode as Encode
import Json.Decode as JD exposing (Decoder, string, maybe)
import Json.Decode.Pipeline exposing (hardcoded, optional, required, requiredAt, optional, optionalAt)


apiURL : String
apiURL =
    "https://gis.navi.cc/nominatim/reverse.php?format=json"



-- Образец запроса
-- https://gis.navi.cc/nominatim/reverse.php?format=json&lat=48.42236333333334&lon=35.02598833333333
--
-- Образец ответа
-- {
--    "place_id":"665693",
--    "licence":"Data © OpenStreetMap contributors, ODbL 1.0. https://osm.org/copyright",
--    "osm_type":"way",
--    "osm_id":"139590054",
--    "lat":"48.4222671",
--    "lon":"35.0256552519265",
--    "display_name":"81, Огородная улица, Днепр, Соборный район, Днепровский городской совет, Днепропетровская область, 49050, Украина",
--    "address":{
--       "house_number":"81",
--       "road":"Огородная улица",
--       "city":"Днепр",
--       "county":"Днепровский городской совет",
--       "state":"Днепропетровская область",
--       "postcode":"49050",
--       "country":"Украина",
--       "country_code":"ua"
--    },
--    "boundingbox":[
--       "48.4221862",
--       "48.4223479",
--       "35.0252809",
--       "35.0260296"
--    ]
-- }


type alias Address =
    { osm_type : String
    , display_name : String
    , road : Maybe String
    , house_number : Maybe String
    , building : Maybe String
    , supermarket : Maybe String
    , neighbourhood : Maybe String
    , suburb : Maybe String
    , city : Maybe String
    , town : Maybe String
    , state : Maybe String
    , country : Maybe String
    }


addressDecoder : Decoder Address
addressDecoder =
    JD.succeed Address
        |> required "osm_type" string
        |> required "display_name" string
        |> optionalAt [ "address", "road" ] (maybe string) Nothing
        |> optionalAt [ "address", "house_number" ] (maybe string) Nothing
        |> optionalAt [ "address", "building" ] (maybe string) Nothing
        |> optionalAt [ "address", "supermarket" ] (maybe string) Nothing
        |> optionalAt [ "address", "neighbourhood" ] (maybe string) Nothing
        |> optionalAt [ "address", "suburb" ] (maybe string) Nothing
        |> optionalAt [ "address", "city" ] (maybe string) Nothing
        |> optionalAt [ "address", "town" ] (maybe string) Nothing
        |> optionalAt [ "address", "state" ] (maybe string) Nothing
        |> optionalAt [ "address", "country" ] (maybe string) Nothing


addressToString : Address -> String
addressToString a =
    let
        compose =
            [ a.road |> Maybe.withDefault ""
            , a.house_number |> Maybe.withDefault ""
            , case a.building of
                Just b ->
                    b

                Nothing ->
                    case a.supermarket of
                        Just spm ->
                            spm

                        Nothing ->
                            case a.neighbourhood of
                                Just ngh ->
                                    ngh

                                Nothing ->
                                    a.suburb |> Maybe.withDefault ""
            , case a.city of
                Just city ->
                    city

                Nothing ->
                    a.town |> Maybe.withDefault ""
            , a.state |> Maybe.withDefault ""
            , a.country |> Maybe.withDefault "0"
            ]

        _ =
            Debug.log "compose" compose
    in
        compose
            |> List.foldl
                (\i l ->
                    if i == "" then
                        l
                    else
                        (if l == "" then
                            i
                         else
                            l ++ ", " ++ i
                        )
                )
                ""



-- if(a.house_number) p.push(a.house_number);
-- if(a.building) {
--     p.push(a.building);
-- } else {
--     if(a.supermarket) {
--         p.push(a.supermarket);
--     } else {
--         if(a.neighbourhood) {
--             p.push(a.neighbourhood);
--         } else {
--             if(a.suburb) p.push(a.suburb);
--         }
--     }
-- }
-- if(a.city) {
--     p.push(a.city);
-- } else {
--     if(a.town) p.push(a.town);
-- }
-- if(a.state) p.push(a.state);
-- if(a.country) p.push(a.country);


getAddress : ( Float, Float ) -> (Result Http.Error Address -> msg) -> Cmd msg
getAddress ( lat, lon ) msg =
    Http.get
        { url = apiURL ++ "&lat=" ++ (String.fromFloat lat) ++ "&lon=" ++ (String.fromFloat lon)
        , expect = Http.expectJson msg addressDecoder
        }
