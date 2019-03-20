import L from 'leaflet';
// import 'leaflet.css';
import '../../node_modules/leaflet/dist/leaflet.css';

var maps = {};

// const tileUrl = 'http://{s}.tiles.wmflabs.org/bw-mapnik/{z}/{x}/{y}.png';
const tileUrl = 'http://{s}.google.com/vt/lyrs=p&x={x}&y={y}&z={z}';
const attribution = '&copy; <a href="http://www.openstreetmap.org/copyright">OpenStreetMap</a>';

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
    console.log("add map element (TBD)", [element]);
    if(element.hasOwnProperty('_leaflet_id')) return;
    var map = L.map(element, {minZoom: 2}).fitWorld();
    L.tileLayer(tileUrl, {
        attribution,
        subdomains: ['mt0', 'mt1', 'mt2', 'mt3'],
        minZoom:1,
        maxZoom: 18
    }).addTo(map);
    // var tandemMoveHandler = tandemMove(map);
    // map.on('moveend', tandemMoveHandler).on('zoomend', tandemMoveHandler);
    maps[element._leaflet_id] = map;
    console.log("added leaflet id", element._leaflet_id);
    // configureMap(element);
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


class LeafletMap extends HTMLElement {
    connectedCallback() {
        var container = document.createElement("div");
        // container.innerHTML = "LeafletMap";
        container.className = "leaflet-map";
        this.appendChild(container);
        console.log('add map', this);
        addMap(container);
        this._leaflet_id = container._leaflet_id;
    }

    disconnectedCallback() {
        // this[VIEW].disconnect();
        console.log('remove map', this);
        maps[this._leaflet_id].remove();
        delete maps[this._leaflet_id];
    }

}

window.customElements.define("leaflet-map", LeafletMap);
