module API.Geo exposing (..)

import Http
import Json.Decode as JD exposing (Decoder, maybe, string)
import Json.Decode.Pipeline exposing (hardcoded, optional, optionalAt, required, requiredAt)
import Json.Encode as Encode


apiURL : String
apiURL =
    "https://gis.navi.cc/nominatim/reverse.php?format=json"



-- Образец запроса
-- https://nominatim.openstreetmap.org/reverse?format=json&lat=48.42236333333334&lon=35.02598833333333
-- https://gis.navi.cc/nominatim/reverse.php?format=json&lat=48.42236333333334&lon=35.02598833333333
-- https://nominatim.openstreetmap.org/reverse.php?format=json&lat=48.408213333333336&lon=35.04905
-- https://gis.navi.cc/nominatim/reverse.php?format=json&lat=48.408213333333336&lon=35.04905
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


optnl =
    Maybe.withDefault ""


woptnl : a -> Maybe a -> a
woptnl d v =
    v |> Maybe.withDefault d


orUse : Maybe a -> Maybe a -> Maybe a
orUse other def =
    case def of
        Just v ->
            Just v

        Nothing ->
            other


addressToString : Address -> String
addressToString a =
    let
        compose =
            [ optnl a.road
            , optnl a.house_number
            , if a.building == a.house_number then
                ""

              else
                a.building
                    |> orUse a.supermarket
                    |> orUse a.neighbourhood
                    |> orUse a.suburb
                    |> optnl
            , a.city
                |> orUse a.town
                |> optnl
            , optnl a.state
            , optnl a.country
            ]
    in
    -- String.join ", " compose
    join compose


join : List String -> String
join =
    List.foldl
        (\i l ->
            if i == "" then
                l

            else if l == "" then
                i

            else
                l ++ ", " ++ i
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
        { url = apiURL ++ "&lat=" ++ String.fromFloat lat ++ "&lon=" ++ String.fromFloat lon
        , expect = Http.expectJson msg addressDecoder
        }



-- getHours : getHours
