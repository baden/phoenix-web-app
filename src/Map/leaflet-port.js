import L from 'leaflet';
// import Lem from 'leaflet-extra-markers';
import PD from 'leaflet-polylinedecorator';
import _ from 'underscore';
// import '.css';
// import 'leaflet.css';
import '../../node_modules/leaflet/dist/leaflet.css';
// import '../../node_modules/leaflet-extra-markers/dist/css/leaflet.extra-markers.min.css';

import icon from 'leaflet/dist/images/marker-icon.png';
import iconShadow from 'leaflet/dist/images/marker-shadow.png';
import iconRetinaUrl from 'leaflet/dist/images/marker-icon-2x.png';

import './leaflet.css';
import {MapTiles} from './tile_layers';
import {MapSettings} from './settings';

import debounce from './debounce';
// import greenIconUrl from 'static/images/markers/leaf-green.png';

var maps = {};

// const tileUrl = 'http://{s}.tiles.wmflabs.org/bw-mapnik/{z}/{x}/{y}.png';
const tileUrl = 'https://{s}.google.com/vt/lyrs=p&x={x}&y={y}&z={z}';
const attribution = '&copy; <a href="http://www.openstreetmap.org/copyright">OpenStreetMap</a>';

const tileLayers = MapTiles();
const settings = MapSettings();
// console.log("settings = ", settings);
// console.log('tileLayers = ', tileLayers);

// console.log("Lem = ", Lem);

// FIX leaflet's default icon path problems with webpack (TRY #1)

delete L.Icon.Default.prototype._getIconUrl;

L.Icon.Default.mergeOptions({
  iconRetinaUrl: require('leaflet/dist/images/marker-icon-2x.png'),
  iconUrl: require('leaflet/dist/images/marker-icon.png'),
  shadowUrl: require('leaflet/dist/images/marker-shadow.png'),
});

// FIX leaflet's default icon path problems with webpack (TRY #2 steel fail)
// let DefaultIcon = L.icon({
//       iconUrl: icon,
//       iconRetinaUrl: iconRetinaUrl,
//       shadowUrl: iconShadow,
//       iconSize: [24,36],
//       iconAnchor: [12,36]
//     });

// let greenIcon = L.icon({
// 	iconUrl: '/static/images/markers/leaf-green.png',
// 	shadowUrl: '/static/images/markers/leaf-shadow.png',
//
// 	iconSize:     [38, 95], // size of the icon
// 	shadowSize:   [50, 64], // size of the shadow
// 	iconAnchor:   [22, 94], // point of the icon which will correspond to marker's location
// 	shadowAnchor: [4, 62],  // the same for the shadow
// 	popupAnchor:  [-3, -76] // point from which the popup should open relative to the iconAnchor
// });


// const redMarker = L.ExtraMarkers.icon({
//     icon: 'fa-car',
//     markerColor: 'pink',
//     shape: 'square',
//     prefix: 'fa'
//   });
// console.log("redMarker = ", redMarker);


// var myIcon = L.icon({
//     iconUrl: 'my-icon.png',
//     iconSize: [38, 95],
//     iconAnchor: [22, 94],
//     popupAnchor: [-3, -76],
//     shadowUrl: 'my-icon-shadow.png',
//     shadowSize: [68, 95],
//     shadowAnchor: [22, 94]
// });

// L.Marker.prototype.options.icon = DefaultIcon;

// FIX leaflet's default icon path problems with webpack
// delete L.Icon.Default.prototype._getIconUrl
// L.Icon.Default.mergeOptions({
//   iconRetinaUrl: require('leaflet/dist/images/marker-icon-2x.png'),
//   iconUrl: require('leaflet/dist/images/marker-icon.png'),
//   shadowUrl: require('leaflet/dist/images/marker-shadow.png')
// })

// function init(id)
// {
//     var map = L.map('map').fitWorld();
//
//     L.tileLayer(tileUrl, {
//         attribution,
//         maxZoom: 18
//     }).addTo(map);
//
// }

export default function map() {

    console.log('Leaflet = ', [leaflet]);

}

// https://github.com/lifemapper/rutabaga/blob/c86857c81f7f827c5bb6f1eef366b74a6e39ddf8/mcpa/statsHeatMapMain.js

function addMap(element) {
    var expanded = false;
    console.log("add map element (TBD)", [element]);
    if(element.hasOwnProperty('_leaflet_id')) return;
    var myOptions = {
        layers: tileLayers.baseLayers[settings.baseLayer],
        minZoom: 2,
        zoomAnimation: true,
        fadeAnimation: false,
        markerZoomAnimation: false,
        zoomControl: false
    };
    var map = L.map(element, myOptions).fitWorld();
    // L.tileLayer(tileUrl, {
    //     attribution,
    //     subdomains: ['mt0', 'mt1', 'mt2', 'mt3'],
    //     minZoom:1,
    //     maxZoom: 18
    // }).addTo(map);
    // var tandemMoveHandler = tandemMove(map);
    // map.on('moveend', tandemMoveHandler).on('zoomend', tandemMoveHandler);

    // tileLayers.baseLayers[defaultLayer].addTo(map);

    var layersControl = new L.Control.Layers(tileLayers.baseLayers);
    layersControl.addTo(map);

    L.control.zoom({
        position: 'bottomleft'
    }).addTo(map);

    map.on('baselayerchange', function(evt) {
        // console.log("Map layer changed to ", evt.name);
        settings.baseLayer = evt.name;
        settings.save();
        // gtag('event', 'map', { event_category: 'change_type', event_label: evt.name });
    });

    maps[element._leaflet_id] = map;
    console.log("added leaflet id", element._leaflet_id);
    // configureMap(element);
    return map;
}

// const MutationObserver = window.MutationObserver || window.WebKitMutationObserver || window.MozMutationObserver;
//
// var observer = new MutationObserver(function(mutations) {
//     mutations.forEach(function(m) {
//         // console.log("mutations", m);
//         m.addedNodes.forEach(function(n) {
//             if (n.getElementsByClassName == null) return;
//             var elements = (n.classList.contains("leaflet-map")) ? [n] : n.getElementsByClassName("leaflet-map");
//             // console.log("mutations elements", [n, elements]);
//             Array.prototype.forEach.call(elements, function(element) {
//                 addMap(element);
//             });
//         });
//         m.removedNodes.forEach(function(n) {
//             if (n.getElementsByClassName == null) return;
//             // var elements = n.getElementsByClassName("leaflet-map");
//             var elements = (n.classList.contains("leaflet-map")) ? [n] : n.getElementsByClassName("leaflet-map");
//             Array.prototype.forEach.call(elements, function(element) {
//                 if (element._leaflet_id != null) {
//                     console.log("removing map with leaflet id", element._leaflet_id);
//                     maps[element._leaflet_id].remove();
//                     delete maps[element._leaflet_id];
//                     // delete mapLayers[element._leaflet_id];
//                 }
//             });
//         });
//         if (m.type == "attributes") {
//             // configureMap(m.target);
//             console.log("attributes", m.target);
//         }
//     });
// });
//
// observer.observe(document.body, {
//     subtree: true,
//     childList: true,
//     attributes: true,
//     attributeFilter: ["data-map-selected-var"],
//     attributeOldValue: true
// });

const minScaleAttr = 'min-scale';

class LeafletMap extends HTMLElement {
    constructor() {
        super();
        console.log("LeafletMap:constructor:", this, L);

        this._center = this.center || {
            lat: 48.5013798,
            lng: 34.6234255
        };
        delete this.center;

        this._markers = this.markers || [];
        delete this.markers;

        this._title = this.title || [];
        delete this.title;

        this._track = this.track || [];
        delete this.track;

        if(false) {
            new MutationObserver((mr) => this._stageElChange(mr))
              .observe(this, { attributes: true, attributeFilter: ["data-map-center"], attributeOldValue: true});
        }

        // static get observedAttributes() {
        //     console.log("observedAttributes");
        //     return [minScaleAttr];
        // }
    }
    // attributeChangedCallback(name, oldValue, newValue) {
    //     console.log("attributeChangedCallback", name, oldValue, newValue);
    //     if (name === minScaleAttr) {
    //         if (this.scale < this.minScale) {
    //             this.setTransform({ scale: this.minScale });
    //         }
    //     }
    // }

    connectedCallback() {
        var container = document.createElement("div");
        // container.innerHTML = "LeafletMap";
        container.className = "leaflet-map";
        this.appendChild(container);
        // var center = this.getAttribute('data-map-center');
        // var values = center.split(",");
        // var lat = parseFloat(values[0]);
        // var lng = parseFloat(values[1]);
        console.log('add map', this, this._center, this._markers);
        var lat = this._center ? this._center.lat : 0.0;
        var lng = this._center ? this._center.lng : 0.0;
        this._map = addMap(container);
        this._map.setView(L.latLng(lat, lng), 15);



        // TRY GeoJSON
        // 48.422656 35.026016
        // var geojsonFeature = {
        //     "type": "Feature",
        //     "properties": {
        //         "name": "Coors Field",
        //         "amenity": "Baseball Stadium",
        //         "popupContent": "This is where the Rockies play!"
        //     },
        //     "geometry": {
        //         "type": "Point",
        //         "coordinates": [35.026016, 48.422656]
        //     }
        // };
        // L.geoJSON(geojsonFeature).addTo(this._map);

        var myLines = [{
            "type": "LineString",
            "coordinates": [[ 35.026016, 48.422656 ], [35.028016, 48.422656], [35.026016, 48.424656]]
        }, {
            "type": "LineString",
            "coordinates": [[-105, 40], [-110, 45], [-115, 55]]
        }];

        // var myLayer = L.geoJSON().addTo(this._map);
        // myLayer.addData(myLines);

        // this._trackLayer = L.geoJSON().addTo(this._map);

        var data_points = {
            "type": "FeatureCollection",
            "name": "test-points-short-named",
            "crs": { "type": "name", "properties": { "name": "urn:ogc:def:crs:OGC:1.3:CRS84" } },
            "features": [
            { "type": "Feature", "properties": { "name": "<span class=\"icon-car_icon image-logo\"></span> " + this._title }, "geometry": { "type": "Point", "coordinates": [ 35.026016, 48.422656 ] } }
            // { "type": "Feature", "properties": { "name": "6"}, "geometry": { "type": "Point", "coordinates": [ -135.02480935075292, 60.672888247036376 ] } },
            // { "type": "Feature", "properties": { "name": "12"}, "geometry": { "type": "Point", "coordinates": [ -135.02449372349508, 60.672615176262731 ] } },
            // { "type": "Feature", "properties": { "name": "25"}, "geometry": { "type": "Point", "coordinates": [ -135.0240752514004, 60.673313811878423 ] } }
            ]};

            // var customTooltip =
            // var customTooltip = document.createElement("div");
            // customTooltip.className = "custom-tooltip";
            // customTooltip.innerHTML = "Boo:<span class=\"icon-car_icon image-logo\"></span>";

            // this.appendChild(container);

            var pointLayer = L.geoJSON(null, {
              pointToLayer: function(feature, latlng){
                const label = String(feature.properties.name) // .bindTooltip can't use straight 'feature.properties.attribute'
                return new L.CircleMarker(latlng, {
                  radius: 1,
              }).bindTooltip( label /*customTooltip*/, {
                  permanent: true,
                  opacity: 1.0,
                  direction: "bottom",
                  className: 'icon-car_icon'
              }).openTooltip();
                }
              });
            pointLayer.addData(data_points);
            this._map.addLayer(pointLayer);

        // this._center_marker = L.marker([lat, lng], {icon: DefaultIcon}).addTo(this._map);
        // L.marker([lat, lng], {icon: redMarker}).addTo(this._map);

        this._leaflet_id = container._leaflet_id;

        const centerChanged = debounce(() => {
            const newCenter = this._map.getCenter();
            if((newCenter.lat != this._center.lat) || (newCenter.lng != this._center.lng)) {
                // console.log("map:move", this._center, newCenter);
                this._center = newCenter;
                this.dispatchEvent(new CustomEvent('centerChanged'));
            }
        }, 100);

        this._map.on('moveend', centerChanged);

        setTimeout(() => {
            if(this._map) this._map.invalidateSize();
        }, 100);

        // const resizeContent = debounce((entries) => {
        //     console.log("resizeObserver", entries);
        // });
        const resizeContent = (entries) => {
            console.log("resizeObserver", entries);
        };

        // const resizeObserver = new ResizeObserver(entries => {
        //     console.log("resizeObserver", entries);
        //     // this._map.invalidateSize();
        // });
        // const resizeObserver = new ResizeObserver(resizeContent);
        // const resizeObserver = new ResizeObserver(_.debounce(resizeContent, 500));
        const resizeObserver = new ResizeObserver(debounce(resizeContent, 500));
        // const resizeObserver = new ResizeObserver(_.throttle(resizeContent, 500));
        resizeObserver.observe(this);
    }

    disconnectedCallback() {
        // this[VIEW].disconnect();
        console.log('remove map', this);
        maps[this._leaflet_id].remove();
        // resizeObserver.unobserve(this);
        delete maps[this._leaflet_id];
    }

    get center() {
        // console.log("get center", this._center);
        return this._center;
    }
    set center(value) {
        // this.htmlElement.setAttribute("cx", value);
        if (value !== null && value.lat !== this._center.lat && value.lng !== this._center.lng) {
            // console.log("set center", value, "old: ", this._center);
            this._center = value;
            if(!this._map) return;
            var lat = this._center.lat;
            var lng = this._center.lng;
            this._map.flyTo(L.latLng(lat, lng), 15);
            this._map.invalidateSize();
            if(this._center_marker) this._center_marker.setLatLng(L.latLng(lat, lng));
        }
    }

    get markers() { return this._markers; }
    set markers(value) {
        if (value !== null && !_.isEqual(value, this._markers)) {
            console.log("set markers", value);

            if(!this._map) {
                console.log("Wtf? Map is not found!");
                return;
            }

            value.forEach(item => {
                let {pos, title} = item;
                // L.marker([pos.lat, pos.lng], {icon: redMarker}).addTo(this._map);
                L.marker([pos.lat, pos.lng]).addTo(this._map);

            });


            this._markers = value;
        }
    }


    get title() { return this._title; }
    set title(value) {
        this._title = value;
    }

    get track() { return this._track; }
    set track(value) {
        if (value !== null && !_.isEqual(value, this._track)) {
            console.log("set track", value);
            this._track = value;

            if(!this._map) {
                console.log("Wtf? Map is not found!");
                return;
            }

            if(this._trackLayer) {
                this._map.removeLayer(this._trackLayer);
            }

            this._trackLayer = L.layerGroup();

            // var layer_Onthogenetic_Juveniles_Migration_13 = L.layerGroup({
            //   attribution: '',
            //   interactive: false,
            //   layerName: 'layer_Onthogenetic_Juveniles_Migration_13',
            //   pane: 'pane_Onthogenetic_Juveniles_Migration_13',
            // });
            //
            // function pop_Onthogenetic_Juveniles_Migration_13(feature, layer) {
            //   var polyline = L.polyline(layer.getLatLngs()).addTo(layer_Onthogenetic_Juveniles_Migration_13);
            //   var arrowHead = L.polylineDecorator(polyline, {
            //     patterns: [
            //       {offset: '100%', repeat: 0, symbol: L.Symbol.arrowHead({pixelSize: 60, polygon: false, pathOptions: {stroke: true}})}
            //     ]
            //   }).addTo(layer_Onthogenetic_Juveniles_Migration_13);
            //   // your code
            // }

            // Style functions
            function onEachFeature(feature, layer) {
                // var congInfo = Object.values(feature.properties.member[cong])[0];
                layer.bindPopup(`Информация пока недоступна.`);
            };

            // console.log("L.polylineDecorator =", L.polylineDecorator);

            this._trackLayer = new L.featureGroup();
            var myLines = L.polyline(value.track).addTo(this._trackLayer);
            // var myLines = L.polyline([[ 48.422656, 35.026016  ], [48.422656, 35.028016], [48.424656, 35.026016]]).addTo(this._trackLayer);
            var arrowHead = L.polylineDecorator(myLines, {
                patterns: [
                    {offset: 0,
                        repeat: 40,
                        // symbol: L.Symbol.dash({pixelSize: 10})
                        symbol: L.Symbol.arrowHead({pixelSize: 8, polygon: false, pathOptions: {color: '#3388ff', stroke: true}})
                    }
                ]
            }).addTo(this._trackLayer);

            this._trackLayer.addTo(this._map);

            // const myLines = [{
            //     "type": "LineString",
            //     "coordinates": value.track
            // }];
            // // this._trackLayer =
            // L.geoJSON(myLines, {
            //         // onEachFeature: pop_Onthogenetic_Juveniles_Migration_13
            //         onEachFeature: (feature, layer) => {
            //             // console.log("onEachFeature", feature, layer);
            //             L.polylineDecorator(layer, {
            //                 patterns: [
            //                     {offset: 0,
            //                         repeat: 40,
            //                         symbol: L.Symbol.arrowHead({pixelSize: 8, polygon: false, pathOptions: {color: '#3388ff', stroke: true}})
            //                     }
            //                 ]
            //             // }).addTo(this._map);; //.addTo(this._trackLayer);
            //             }).addTo(this._trackLayer); //.addTo(this._trackLayer);
            //         },
            //         // onEachFeature: onEachFeature,
            //         // pointToLayer: iro
            //         // pointToLayer: function (feature, latlng) {
            //         //     return L.marker(latlng, {
            //         //         icon: arrowIcon,
            //         //         riseOnHover: true,
            //         //         rotationAngle: feature.properties.orientation,
            //         //         rotationOrigin: 'center center'
            //         //     })
            //         // }
            //     }).addTo(this._trackLayer);
            //
            // this._trackLayer.addTo(this._map);
            // if(this._trackLayer) {
            //     console.log("update data", myLines);
            // this._trackLayer.addData(myLines);
            // }
            console.log("_trackLayer", this._trackLayer);


        }
    }

    // _stageElChange(mutations) {
    //     const me = this;
    //     console.log("_stageElChange", this, mutations);
    //     mutations.forEach(function(m) {
    //         switch (m.attributeName) {
    //             case 'data-map-center':
    //                 var center = me.getAttribute('data-map-center');
    //                 var values = center.split(",");
    //                 var lat = parseFloat(values[0]);
    //                 var lng = parseFloat(values[1]);
    //                 console.log("Pan map to ", lat, ', ', lng);
    //                 me._map.flyTo(L.latLng(lat, lng), 15);
    //                 break;
    //             default:
    //         };
    //     });
    // }

}

window.customElements.define("leaflet-map", LeafletMap);

// const debounce = func => {
//   let token;
//   return function() {
//     const later = () => {
//       token = null;
//       func.apply(null, arguments);
//     };
//     cancelIdleCallback(token);
//     token = requestIdleCallback(later);
//   };
// };
