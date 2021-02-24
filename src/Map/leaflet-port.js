import L from 'leaflet';
import Lem from 'leaflet-extra-markers';
// import '.css';
// import 'leaflet.css';
import '../../node_modules/leaflet/dist/leaflet.css';
import '../../node_modules/leaflet-extra-markers/dist/css/leaflet.extra-markers.min.css';

import icon from 'leaflet/dist/images/marker-icon.png';
import iconShadow from 'leaflet/dist/images/marker-shadow.png';
import iconRetinaUrl from 'leaflet/dist/images/marker-icon-2x.png';

import './leaflet.css';
import {MapTiles} from './tile_layers';
import {MapSettings} from './settings';

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

// FIX leaflet's default icon path problems with webpack
let DefaultIcon = L.icon({
      iconUrl: icon,
      // iconRetinaUrl: iconRetinaUrl,
      shadowUrl: iconShadow,
      iconSize: [24,36],
      iconAnchor: [12,16]
    });

let greenIcon = L.icon({
	iconUrl: '/static/images/markers/leaf-green.png',
	shadowUrl: '/static/images/markers/leaf-shadow.png',

	iconSize:     [38, 95], // size of the icon
	shadowSize:   [50, 64], // size of the shadow
	iconAnchor:   [22, 94], // point of the icon which will correspond to marker's location
	shadowAnchor: [4, 62],  // the same for the shadow
	popupAnchor:  [-3, -76] // point from which the popup should open relative to the iconAnchor
});

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
        markerZoomAnimation: false
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
        console.log("LeafletMap:constructor", this, L);

        this._center = [48.5013798, 34.6234255];

        new MutationObserver((mr) => this._stageElChange(mr))
          .observe(this, { attributes: true, attributeFilter: ["data-map-center"], attributeOldValue: true});

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
        console.log('add map', this, this._center);
        var lat = this._center ? this._center[0] : 0.0;
        var lng = this._center ? this._center[1] : 0.0;
        this._map = addMap(container);
        this._map.setView(L.latLng(lat, lng), 15);


        var redMarker = L.ExtraMarkers.icon({
            icon: 'fa-car',
            markerColor: 'pink',
            shape: 'square',
            prefix: 'fa'
          });
        console.log("redMarker = ", redMarker);

        // this._center_marker = L.marker([lat, lng], {icon: DefaultIcon}).addTo(this._map);
        L.marker([lat, lng], {icon: redMarker}).addTo(this._map);

        this._leaflet_id = container._leaflet_id;
    }

    disconnectedCallback() {
        // this[VIEW].disconnect();
        console.log('remove map', this);
        maps[this._leaflet_id].remove();
        delete maps[this._leaflet_id];
    }

    get center() {
        console.log("get center");
        return this._center;
        // return Number(this.htmlElement.getAttribute("cx"));
    }
    set center(value) {
        // this.htmlElement.setAttribute("cx", value);
        console.log("set center", value);
        this._center = value;
        if(!this._map) return;
        var lat = this._center[0];
        var lng = this._center[1];
        this._map.flyTo(L.latLng(lat, lng), 15);
        if(this._center_marker) this._center_marker.setLatLng(L.latLng(lat, lng));
    }

    _stageElChange(mutations) {
        const me = this;
        console.log("_stageElChange", this, mutations);
        mutations.forEach(function(m) {
            switch (m.attributeName) {
                case 'data-map-center':
                    var center = me.getAttribute('data-map-center');
                    var values = center.split(",");
                    var lat = parseFloat(values[0]);
                    var lng = parseFloat(values[1]);
                    console.log("Pan map to ", lat, ', ', lng);
                    me._map.flyTo(L.latLng(lat, lng), 15);
                    break;
                default:
            };
        });

    }

}

window.customElements.define("leaflet-map", LeafletMap);
