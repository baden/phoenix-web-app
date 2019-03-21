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
        console.log("LeafletMap:constructor", this);

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
        if(!this._map) return;
        console.log("set center", value);
        this._center = value;
        var lat = this._center[0];
        var lng = this._center[1];
        this._map.flyTo(L.latLng(lat, lng), 15);
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
