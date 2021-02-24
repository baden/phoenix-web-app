export function MapTiles() {
    // Links:
    // https://github.com/RSteenson/webtest/blob/b7dd80f98709785ee896341a10b436e443ee5065/site_libs/leaflet-binding-2.0.2/lib/leaflet-providers/leaflet-providers.js

    // console.log("Init LeafletTileLayers service");
    // Чет не получается переиспользовать их прямо. Какая-то привязка к старой карте остается.
    return function() {
        // var NationalGeographicMap = L.tileLayer('http://server.arcgisonline.com/ArcGIS/rest/services/NatGeo_World_Map/MapServer/tile/{z}/{y}/{x}.png', {
        //   attribution: 'Tiles &copy; Esri &mdash; National Geographic, Esri, DeLorme, NAVTEQ, UNEP-WCMC, USGS, NASA, ESA, METI, NRCAN, GEBCO, NOAA, iPC',
        //   minZoom: 2,
        //   maxZoom: 12
        // });
        var OpenStreetMap_BlackAndWhite = L.tileLayer('http://{s}.tiles.wmflabs.org/bw-mapnik/{z}/{x}/{y}.png', {
            attribution: '&copy; <a href="http://www.openstreetmap.org/copyright">OpenStreetMap</a>',
            minZoom: 1,
            maxZoom: 18
        });
        var OpenStreetMap_Hikebike = L.tileLayer('http://{s}.tiles.wmflabs.org/hikebike/{z}/{x}/{y}.png', {
            attribution: '&copy; <a href="http://www.openstreetmap.org/copyright">OpenStreetMap</a>',
            minZoom: 1,
            maxZoom: 18
        });
        // var retina = L.Browser.retina ? '@2x' : '';
        var retina = '';
        var OpenStreetMap_France2 = L.tileLayer('http://{s}.tile.openstreetmap.fr/hot/{z}/{x}/{y}' + retina + '.png', {
            attribution: '&copy; Openstreetmap France | &copy; <a href="http://www.openstreetmap.org/copyright">OpenStreetMap</a>',
            minZoom: 1,
            maxZoom: 18
        });
        // https: also suppported.
        var Thunderforest_Outdoors = L.tileLayer('http://{s}.tile.thunderforest.com/outdoors/{z}/{x}/{y}.png', {
            attribution: '&copy; <a href="http://www.thunderforest.com/">Thunderforest</a>, &copy; <a href="http://www.openstreetmap.org/copyright">OpenStreetMap</a>'
        });
        // https: also suppported.
        var Thunderforest_Landscape = L.tileLayer('http://{s}.tile.thunderforest.com/landscape/{z}/{x}/{y}.png', {
            attribution: '&copy; <a href="http://www.thunderforest.com/">Thunderforest</a>, &copy; <a href="http://www.openstreetmap.org/copyright">OpenStreetMap</a>'
        });
        var Thunderforest_Pioneer = L.tileLayer('http://{s}.tile.thunderforest.com/pioneer/{z}/{x}/{y}.png', {
            attribution: '&copy; <a href="http://www.thunderforest.com/">Thunderforest</a>, &copy; <a href="http://www.openstreetmap.org/copyright">OpenStreetMap</a>'
        });
        var Thunderforest_Cycle = L.tileLayer('http://{s}.tile.thunderforest.com/cycle/{z}/{x}/{y}.png', {
            attribution: '&copy; <a href="http://www.thunderforest.com/">Thunderforest</a>, &copy; <a href="http://www.openstreetmap.org/copyright">OpenStreetMap</a>'
        });
        var Thunderforest_Transport = L.tileLayer('http://{s}.tile.thunderforest.com/transport/{z}/{x}/{y}.png', {
            attribution: '&copy; <a href="http://www.thunderforest.com/">Thunderforest</a>, &copy; <a href="http://www.openstreetmap.org/copyright">OpenStreetMap</a>'
        });
        var Thunderforest_SpinalMap = L.tileLayer('http://{s}.tile.thunderforest.com/spinal-map/{z}/{x}/{y}.png', {
            attribution: '&copy; <a href="http://www.thunderforest.com/">Thunderforest</a>, &copy; <a href="http://www.openstreetmap.org/copyright">OpenStreetMap</a>'
        });
        // // var MapQuestOpen_OSM = L.tileLayer('http://otile1.mqcdn.com/tiles/1.0.0/osm/${z}/${x}/${y}.png', {
        // var MapQuestOpen_OSM = L.tileLayer('http://otile{s}.mqcdn.com/tiles/1.0.0/{type}/{z}/{x}/{y}.{ext}', {
        //   type: 'map',
        //   ext: 'jpg',
        //   attribution: 'Tiles Courtesy of <a href="http://www.mapquest.com/">MapQuest</a> &mdash; Map data &copy; <a href="http://www.openstreetmap.org/copyright">OpenStreetMap</a>',
        //   subdomains: '1234'
        // });
        // https: also suppported.
        var Esri_WorldStreetMap = L.tileLayer('http://server.arcgisonline.com/ArcGIS/rest/services/World_Street_Map/MapServer/tile/{z}/{y}/{x}', {
            attribution: 'Tiles &copy; Esri &mdash; Source: Esri, DeLorme, NAVTEQ, USGS, Intermap, iPC, NRCAN, Esri Japan, METI, Esri China (Hong Kong), Esri (Thailand), TomTom, 2012'
        });
        // https: also suppported.
        var Esri_WorldTopoMap = L.tileLayer('http://server.arcgisonline.com/ArcGIS/rest/services/World_Topo_Map/MapServer/tile/{z}/{y}/{x}', {
            attribution: 'Tiles &copy; Esri &mdash; Esri, DeLorme, NAVTEQ, TomTom, Intermap, iPC, USGS, FAO, NPS, NRCAN, GeoBase, Kadaster NL, Ordnance Survey, Esri Japan, METI, Esri China (Hong Kong), and the GIS User Community'
        });
        // https: also suppported.
        var OpenMapSurfer_Roads = L.tileLayer('http://korona.geog.uni-heidelberg.de/tiles/roads/x={x}&y={y}&z={z}', {
            maxZoom: 18,
            attribution: 'Imagery from <a href="http://giscience.uni-hd.de/">GIScience Research Group @ University of Heidelberg</a> &mdash; Map data &copy; <a href="http://www.openstreetmap.org/copyright">OpenStreetMap</a>'
        });
        var OpenMapSurfer_Roadsg = L.tileLayer('http://korona.geog.uni-heidelberg.de/tiles/roadsg/x={x}&y={y}&z={z}', {
            maxZoom: 18,
            attribution: 'Imagery from <a href="http://giscience.uni-hd.de/">GIScience Research Group @ University of Heidelberg</a> &mdash; Map data &copy; <a href="http://www.openstreetmap.org/copyright">OpenStreetMap</a>'
        });
        var OpenMapSurfer_Adminb = L.tileLayer('http://korona.geog.uni-heidelberg.de/tiles/adminb/x={x}&y={y}&z={z}', {
            maxZoom: 18,
            attribution: 'Imagery from <a href="http://giscience.uni-hd.de/">GIScience Research Group @ University of Heidelberg</a> &mdash; Map data &copy; <a href="http://www.openstreetmap.org/copyright">OpenStreetMap</a>'
        });
        // https: also suppported.
        var HERE_hybridDay = L.tileLayer('http://{s}.{base}.maps.cit.api.here.com/maptile/2.1/{type}/{mapID}/hybrid.day/{z}/{x}/{y}/{size}/{format}?app_id={app_id}&app_code={app_code}&lg={language}', {
            attribution: 'Map &copy; 1987-2014 <a href="http://developer.here.com">HERE</a>',
            subdomains: '1234',
            mapID: 'newest',
            app_id: '<your app_id>',
            app_code: '<your app_code>',
            base: 'aerial',
            maxZoom: 18,
            type: 'maptile',
            language: 'eng',
            format: 'png8',
            size: '256'
        });
        // https: also suppported.
        var MapBox = L.tileLayer('http://api.tiles.mapbox.com/v4/{id}/{z}/{x}/{y}.png?access_token={accessToken}', {
            attribution: 'Imagery from <a href="http://mapbox.com/about/maps/">MapBox</a> &mdash; Map data &copy; <a href="http://www.openstreetmap.org/copyright">OpenStreetMap</a>',
            subdomains: 'abcd',
            id: '<your id>',
            accessToken: '<your accessToken>'
        });
        // var streets = L.tileLayer('https://api.tiles.mapbox.com/v4/{id}/{z}/{x}/{y}.png?access_token=pk.eyJ1IjoibWFwYm94IiwiYSI6ImNpandmbXliNDBjZWd2M2x6bDk3c2ZtOTkifQ._QA7i5Mpkd_m30IGElHziw', {
        //   id: 'mapbox.streets',
        //   attribution: 'Imagery from <a href="http://mapbox.com/about/maps/">MapBox</a> &mdash; Map data &copy; <a href="http://www.openstreetmap.org/copyright">OpenStreetMap</a>'
        // });
        // var grayscale = L.tileLayer('https://api.tiles.mapbox.com/v4/{id}/{z}/{x}/{y}.png?access_token=pk.eyJ1IjoibWFwYm94IiwiYSI6ImNpandmbXliNDBjZWd2M2x6bDk3c2ZtOTkifQ._QA7i5Mpkd_m30IGElHziw', {
        //   id: 'mapbox.light',
        //   attribution: 'Imagery from <a href="http://mapbox.com/about/maps/">MapBox</a> &mdash; Map data &copy; <a href="http://www.openstreetmap.org/copyright">OpenStreetMap</a>'
        // });
        // var cloudmade = L.tileLayer('http://{s}.tile.cloudmade.com/d4fc77ea4a63471cab2423e66626cbb6/997/256/{z}/{x}/{y}.png', {
        //   attribution: 'Map data &copy; <a href="http://openstreetmap.org">OpenStreetMap</a> contributors, <a href="http://creativecommons.org/licenses/by-sa/2.0/">CC-BY-SA</a>, Imagery © <a href="http://cloudmade.com">CloudMade</a>',
        //   maxZoom: 18
        // });
        var googleTerrain = L.tileLayer('https://{s}.google.com/vt/lyrs=p&x={x}&y={y}&z={z}', {
            maxZoom: 18,
            subdomains: ['mt0', 'mt1', 'mt2', 'mt3']
        });
        var googleCN = L.tileLayer('http://www.google.cn/maps/vt?lyrs=m@189&gl=cn&x={x}&y={y}&z={z}', {
            attribution: 'WIP',
            maxZoom: 18,
            id: 'mapbox.streets'
        });

        var OpenStreetMap_SE = L.tileLayer('http://{s}.tile.openstreetmap.se/hydda/full/{z}/{x}/{y}.png', {
            attribution: '&copy; <a href="http://www.openstreetmap.org/copyright">OpenStreetMap</a>',
            minZoom: 1,
            maxZoom: 18
        });
        var OpenStreetMap_SE_Base = L.tileLayer('http://{s}.tile.openstreetmap.se/hydda/base/{z}/{x}/{y}.png', {
            attribution: '&copy; <a href="http://www.openstreetmap.org/copyright">OpenStreetMap</a>',
            minZoom: 1,
            maxZoom: 18
        });
        var OpenStreetMap_SE_RAL = L.tileLayer('http://{s}.tile.openstreetmap.se/hydda/roads_and_labels/{z}/{x}/{y}.png', {
            attribution: '&copy; <a href="http://www.openstreetmap.org/copyright">OpenStreetMap</a>',
            minZoom: 1,
            maxZoom: 18
        });

        var baseLayers = {
            // "National Geographic": NationalGeographicMap,
            "OpenStreetMap": L.tileLayer('https://{s}.tile.openstreetmap.org/{z}/{x}/{y}.png', {
                attribution: '&copy; <a href="http://www.openstreetmap.org/copyright">OpenStreetMap</a>',
                minZoom: 1,
                maxZoom: 18
            }),
            "Google Maps": L.tileLayer('http://{s}.google.com/vt/lyrs=m&x={x}&y={y}&z={z}', {
                maxZoom: 18,
                subdomains: ['mt0', 'mt1', 'mt2', 'mt3']
            }),
            "Esri WorldImagery": L.tileLayer('http://server.arcgisonline.com/ArcGIS/rest/services/World_Imagery/MapServer/tile/{z}/{y}/{x}', {
                maxZoom: 18,
                attribution: 'Tiles &copy; Esri &mdash; Source: Esri, i-cubed, USDA, USGS, AEX, GeoEye, Getmapping, Aerogrid, IGN, IGP, UPR-EGP, and the GIS User Community'
            }),
            "Google Satellite": L.tileLayer('http://{s}.google.com/vt/lyrs=s&x={x}&y={y}&z={z}', {
                maxZoom: 18,
                subdomains: ['mt0', 'mt1', 'mt2', 'mt3']
            }),
            "Google Hybrid": L.tileLayer('http://{s}.google.com/vt/lyrs=s,h&x={x}&y={y}&z={z}', {
                maxZoom: 18,
                subdomains: ['mt0', 'mt1', 'mt2', 'mt3']
            }),
            "2 Gis": L.tileLayer('http://tile{s}.maps.2gis.com/tiles?x={x}&y={y}&z={z}&v=10', {
                maxZoom: 18,
                subdomains: '0123',
                errorTileUrl: 'http://maps.api.2gis.ru/images/nomap.png',
                attribution: '<a href="http://http://2gis.ru/">2GIS</a> Layer | RplusMgmt',
            }),
            "Візіком": L.tileLayer('http://tms{s}.visicom.ua/2.0.0/planet3/base_uk/{z}/{x}/{y}.png', {
                maxZoom: 19,
                tms: true,
                // attribution: 'Данные компании © 2017 <a href="http://visicom.ua/">Визиком</a>',
                attribution: 'Картографічні дані © 2018 ПрАТ <a href="http://visicom.ua/">«Візіком»</a>.',
                subdomains: '123'
            }),
        };
        // if (extend) {
        var extendLayers = {
            "Візіком RU": L.tileLayer('http://tms{s}.visicom.ua/2.0.0/planet3/base_ru/{z}/{x}/{y}.png', {
                maxZoom: 19,
                tms: true,
                // attribution: 'Данные компании © 2017 <a href="http://visicom.ua/">Визиком</a>',
                attribution: 'Картографічні дані © 2018 ПрАТ <a href="http://visicom.ua/">«Візіком»</a>.',
                subdomains: '123'
            }),
            "Візіком EN": L.tileLayer('http://tms{s}.visicom.ua/2.0.0/planet3/base_en/{z}/{x}/{y}.png', {
                maxZoom: 19,
                tms: true,
                // attribution: 'Данные компании © 2017 <a href="http://visicom.ua/">Визиком</a>',
                attribution: 'Картографічні дані © 2018 ПрАТ <a href="http://visicom.ua/">«Візіком»</a>.',
                subdomains: '123'
            }),
            // Альтернативные карты
            "OpenStreetMap-DE": L.tileLayer('http://{s}.tile.openstreetmap.de/tiles/osmde/{z}/{x}/{y}.png', {
                attribution: '&copy; <a href="http://www.openstreetmap.org/copyright">OpenStreetMap</a>',
                minZoom: 1,
                maxZoom: 18
            }),
            "OpenStreetMap-FR": L.tileLayer('http://{s}.tile.openstreetmap.fr/osmfr/{z}/{x}/{y}.png', {
                attribution: '&copy; Openstreetmap France | &copy; <a href="http://www.openstreetmap.org/copyright">OpenStreetMap</a>',
                minZoom: 1,
                maxZoom: 18
            }),
            "OpenStreetMap B&W": OpenStreetMap_BlackAndWhite,
            "OpenStreetMap Hikebike": OpenStreetMap_Hikebike,
            "OpenStreetMap-SE": OpenStreetMap_SE,
            // "OpenStreetMap-SE Base": OpenStreetMap_SE_Base,
            "OpenStreetMap-SE R&L": OpenStreetMap_SE_RAL,
            "OpenStreetMap-FR2": OpenStreetMap_France2,
            "Thunderforest Outdoors": Thunderforest_Outdoors,
            "Thunderforest Landscape": Thunderforest_Landscape,
            "Thunderforest Pioneer": Thunderforest_Pioneer,
            "Thunderforest Cycle": Thunderforest_Cycle,
            "Thunderforest Transp": Thunderforest_Transport,
            "Thunderforest Spinal": Thunderforest_SpinalMap,
            "Thunderforest Dark": L.tileLayer('http://{s}.tile.thunderforest.com/transport-dark/{z}/{x}/{y}.png', {
                attribution: '&copy; <a href="http://www.thunderforest.com/">Thunderforest</a>, &copy; <a href="http://www.openstreetmap.org/copyright">OpenStreetMap</a>'
            }),
            "OpenMapSurfer Roads": OpenMapSurfer_Roads,
            "OpenMapSurfer Adminb": OpenMapSurfer_Adminb,
            "OpenMapSurfer G/S": OpenMapSurfer_Roadsg,
            // "MapQuestOpen": MapQuestOpen_OSM,
            "Esri WorldStreetMap": Esri_WorldStreetMap,
            "Esri WorldTopoMap": Esri_WorldTopoMap,
            "MtbMap": L.tileLayer('http://tile.mtbmap.cz/mtbmap_tiles/{z}/{x}/{y}.png', {
                attribution: '{attribution.OpenStreetMap} &amp; USGS'
            }),
            //"HERE HybridDay": HERE_hybridDay,
            //"MapBox": MapBox,
            // "cloudmade": cloudmade,
            // "Streets": streets,
            // "Grayscale": grayscale,
            "Google Terrain": googleTerrain,
            // "YandexDefault": YandexDefault,

            'Stamen': L.tileLayer(
                'http://{s}.tile.stamen.com/toner/{z}/{x}/{y}.png', {
                    attribution: 'Map tiles by <a href="http://stamen.com">Stamen Design</a>, ' +
                        '<a href="http://creativecommons.org/licenses/by/3.0">CC BY 3.0</a>, ' +
                        '&copy; <a href="http://osm.org/copyright">OpenStreetMap</a> contributors'
                }
            ),
            'Stamen1': L.tileLayer(
                '//stamen-tiles-{s}.a.ssl.fastly.net/terrain/{z}/{x}/{y}.{ext}', {
                    attribution: 'Map tiles by <a href="http://stamen.com">Stamen Design</a>, ' +
                        '<a href="http://creativecommons.org/licenses/by/3.0">CC BY 3.0</a>, ' +
                        '&copy; <a href="http://osm.org/copyright">OpenStreetMap</a> contributors',
                    ext: 'png'
                }
            ),
            "CartoDB Light": L.tileLayer(
                'https://cartodb-basemaps-{s}.global.ssl.fastly.net/{variant}/{z}/{x}/{y}.png', {
                    attribution: '{attribution.OpenStreetMap} &copy; <a href="http://cartodb.com/attributions">CartoDB</a>',
                    subdomains: 'abcd',
                    maxZoom: 18,
                    variant: 'light_all'
                }),
            "CartoDB Dark": L.tileLayer(
                'https://cartodb-basemaps-{s}.global.ssl.fastly.net/{variant}/{z}/{x}/{y}.png', {
                    attribution: '{attribution.OpenStreetMap} &copy; <a href="http://cartodb.com/attributions">CartoDB</a>',
                    subdomains: 'abcd',
                    maxZoom: 18,
                    variant: 'dark_all'
                }),
            "Forte": L.tileLayer('https://{s}.tiles.quaidorsay.fr/tile/forteen/{z}/{x}/{y}.png', {
                name: 'General Purpose',
                attribution: '<a href="https://github.com/tilery/pianoforte" target="_blank">Yohan Boniface</a>',
                maxNativeZoom: 18
            }),
            "OpenTopoMap": L.tileLayer('http://{s}.tile.opentopomap.org/{z}/{x}/{y}.png', {
                attribution: 'Map data: &copy; <a href="http://www.openstreetmap.org/copyright">OpenStreetMap</a>, <a href="http://viewfinderpanoramas.org">SRTM</a> | Map style: &copy; <a href="https://opentopomap.org">OpenTopoMap</a> (<a href="https://creativecommons.org/licenses/by-sa/3.0/">CC-BY-SA</a>)',
                minZoom: 1,
                maxZoom: 16
            }),
        };
        return {
            defaultLayer: "OpenStreetMap",
            baseLayers: baseLayers,
            extendLayers: extendLayers
            // overlays: overlays
        };
    }();
}
