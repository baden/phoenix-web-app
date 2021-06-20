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
// import './eventmarker.css';
import {MapTiles} from './tile_layers';
import {MapSettings} from './settings';

import debounce from './debounce';
import gps from './navi_api';
// import * as d3 from 'd3';
console.log("d3.js is here", d3);
// import greenIconUrl from 'static/images/markers/leaf-green.png';

import EventMarker from './eventmarker';
// console.log("EventMarker", EventMarker);
import {mIcon, iIcon} from './markers';

var maps = {};

// const tileUrl = 'http://{s}.tiles.wmflabs.org/bw-mapnik/{z}/{x}/{y}.png';
const tileUrl = 'https://{s}.google.com/vt/lyrs=p&x={x}&y={y}&z={z}';
const attribution = '&copy; <a href="http://www.openstreetmap.org/copyright">OpenStreetMap</a>';

const tileLayers = MapTiles();
const settings = MapSettings();

import {center_controls} from './center-controls.js';
console.log("center_controls = ", center_controls);
// Patch Leflet for support center controls
center_controls(L);
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


const FSOURCE = {
    UNKNOWN:        0,
    SUDDENSTOP:     1,
    STOPACC:        2,
    TIMESTOPACC:    3,
    SLOW:           4,
    TIMEMOVE:       5,
    START:          6,
    TIMESTOP:       7,
    ANGLE:          8,
    DELTALAT:       9,
    DELTALONG:      10,
    DELTA:          11,
    DU:             12, // Фиксация по дельте изменения внешнего напряжения
    UMAX:           13, // Фиксация по превышению внешнего напряжения установленного порога
    SUDDENSTART:    14, // Это признак возможных проблем с акселерометром
    SUDDENPOS:      15, // Это признак возможных проблем с акселерометром
    TIMEINIT:       16  // Фиксация точек при первоначальной запитке
};

export default function map() {

    console.log('Leaflet = ', [leaflet]);

}

// https://github.com/lifemapper/rutabaga/blob/c86857c81f7f827c5bb6f1eef366b74a6e39ddf8/mcpa/statsHeatMapMain.js

function addMap(element) {
    var expanded = false;
    console.log("add map element (TBD)", [element]);
    if(element.hasOwnProperty('_leaflet_id')) return;


    const currentPos = L.layerGroup([]);
    // maps[element._leaflet_id]
    const overlayMaps = {
        "Текущее положение": currentPos
    };


    var myOptions = {
        layers: [tileLayers.baseLayers[settings.baseLayer], currentPos],
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



    var layersControl = new L.Control.Layers(tileLayers.baseLayers, overlayMaps, {autoZIndex: true});
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

    // TODO: Возможно стоит воспользоваться этим?
    // https://github.com/domoritz/leaflet-locatecontrol/blob/gh-pages/src/L.Control.Locate.js

    let uRhere;
    map.on('locationfound', (ev) => {
        console.log("locationfound", ev);
        uRhere = ev.latlng;
        L.marker([ev.latlng.lat, ev.latlng.lng], {title: "U R here", icon: mIcon('face')})
            .bindTooltip( String("Вы здесь"), {
                permanent: false,
                opacity: 0.7,
                direction: "bottom",
                className: 'icon-car_icon'
            })
            .addTo(currentPos);
            // addLayer
        // mIncon([ev.latlng.lat, ev.latlng.lng]).addTo(map);
        // ev.latlng
    });
    map.on('locationerror', (ev) => {
        console.log("locationerror", ev);
    });
    map.locate({
        // watch: true,
        // setView: true,
        // maxZoom: 14,
        enableHighAccuracy: true
    });


    const Mapmode = L.Control.extend({
        options: { position: 'bottomleft'},
        onAdd: map => {
            const container = L.DomUtil.create('div', 'leaflet-control-layers leaflet-control-layers-expanded leaflet-control hovered-control');
            container.id = 'leaflet-control-custom-container-buffer';
            container.style = 'padding-right: 5px;padding-bottom: 2px;';
            container.title = 'Показать где я';
            // const item = L.DomUtil.create('div', null, container);
            container.innerHTML = `<i style="font-size: 20px; margin: 0; padding: 0" class="material-icons">location_searching</i>`;

            // const checkboxInnerContainer = L.DomUtil.create('div', 'leaflet-control-custom-checkbox-buffer-container', checkbox
            L.DomEvent.on(container, 'click', event => {
                console.log("clicked", event);
                if(uRhere) {
                    // debounce
                    map.flyTo(uRhere);
                }
                // this.setState({ showBuffer: event.target.checked })
            });
            return container;
        }
    });
    map.addControl(new Mapmode());

    // Пока не уверен что хочу сюда это перенести.
    if(false) {
        const Tracks = L.Control.extend({
            options: {position: 'topcenter'},
            onAdd: map => {
                const container = L.DomUtil.create('div', 'leaflet-control-layers leaflet-control-layers-expanded leaflet-control hovered-control');
                container.innerHTML = `TPB(Tracks)`
                return container;

            }
        });
        map.addControl(new Tracks());
    }


    maps[element._leaflet_id] = map;
    // console.log("added leaflet id", element._leaflet_id);
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
            // console.log("resizeObserver", entries);
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

    // Отложенная функция смены положения или отображения трека
    lazyView(func, wait) {
        console.log("lazyView:call");
        const context = this;
        const later = () => {
            console.log("lazyView:done");
            this.lazyTimeout = null;
            func.apply(context);
        };
        clearTimeout(this.lazyTimeout);
        this.lazyTimeout = setTimeout(later, wait);
    }


    get center() {
        // console.log("get center", this._center);
        return this._center;
    }
    set center(value) {
        // this.htmlElement.setAttribute("cx", value);
        if (value !== null && value.lat !== this._center.lat && value.lng !== this._center.lng) {
            console.log("set center", value, "old: ", this._center);
            this._center = value;
            if(!this._map) return;
            var lat = this._center.lat;
            var lng = this._center.lng;
            this.lazyView(() => { this._map.flyTo(L.latLng(lat, lng), 15); }, 100);
            // this._map.flyTo(L.latLng(lat, lng), 15);
            this._map.invalidateSize();
            if(this._center_marker) this._center_marker.setLatLng(L.latLng(lat, lng));
        }
    }

    get markers() { return this._markers; }
    set markers(value) {
        if (value !== null && !_.isEqual(value, this._markers)) {
            console.log("set markers", value);

            if(!this._map) {
                console.warn("Wtf? Map is not found! Use promise or something lazy");
                return;
            }

            value.forEach(item => {
                let {pos, title, icon} = item;
                // L.marker([pos.lat, pos.lng], {icon: redMarker}).addTo(this._map);
                // const tooltip = `${title}`;
                const marker = L.marker([pos.lat, pos.lng], {icon: iIcon(icon)})
                    .bindTooltip( String(title), {
                        permanent: false,
                        opacity: 0.7,
                        direction: "bottom",
                        className: 'icon-car_icon'
                    })
                    // .openTooltip()
                    .addTo(this._map);

                // setTimeout(() => {
                //     marker.closeTooltip()
                // }, 5000);

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

            // Весь функционал вынесен сюда.
            if((value.sysId == "") || (value.day == "")) {
                if(this._map && this._trackLayer) {
                    this._map.removeLayer(this._trackLayer);
                }
                return;
            }

            const [d,m,y] = value.day.split('/');
            const day = new Date(y|0, (m|0)-1, d|0);

            const from = ~~((+day) / 3600000)
            const to = from + 24;

            console.log("Load track for", Intl.DateTimeFormat().format(day), from, to);

            // return ;

            gps(value.sysId, from, to)
                .then(data => {
                    console.log("parsed=", data);

                    if(!this._map) {
                        console.log("Wtf? Map is not found!");
                        return;
                    }

                    if(this._trackLayer) {
                        this._map.removeLayer(this._trackLayer);
                    }

                    this._trackLayer = L.layerGroup();

                    function onEachFeature(feature, layer) {
                        // var congInfo = Object.values(feature.properties.member[cong])[0];
                        layer.bindPopup(`Информация пока недоступна.`);
                    };

                    this._trackLayer = new L.featureGroup();
                    const myLines = map_path(data.track, this._trackLayer);
                    path_decorator(myLines, this._trackLayer );

                    // // var myLines = L.polyline(data.track, {
                    // //     smoothFactor: 1.0
                    // // }).addTo(this._trackLayer);
                    //
                    let index = 0;
                    const eventMarker = (e) => {
                        let title = '?';

                        switch(e.type) {
                            case 'START':
                                title = 'S';
                                break;
                            case 'HOLD':
                                title = '';
                                break;
                            case 'STOP':
                                title = `${index}`;
                                index++;
                                break;
                            case 'FINISH':
                                title = 'F';
                                break;
                        }
                        return new L.Marker([e.position.lat, e.position.lng], {
                            icon: new L.DivIcon({
                                className: `stop-marker stop-marker-${e.type}`,
                                html: `<span>${title}</span>`
                            })
                        });

                    }

                    // let markers = [];
                    data.events.forEach((e, i) => {
                        // console.log("event", e);
                        // TODO: Вынести это в отдельный модуль
                        eventMarker(e).addTo(this._trackLayer);
                    });

                    // const eventmarker = new EventMarker();
                    // console.log("eventmarker", eventmarker);
                    // eventmarker.addTo(this._trackLayer);
                    // eventmarker.setData(data.events);

                    this._trackLayer.addTo(this._map);

                    this.lazyView(() => {this._map.fitBounds(data.bounds)}, 100);
                    // this._map.fitBounds(data.bounds);
                    if(this._map.zoom > 17) this._map.setZoom(17);



                });
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

const map_path = (track, layer) => L.polyline(track, {
    smoothFactor: 1.6
}).addTo(layer);

const path_decorator = (track, layer) => L.polylineDecorator(track, {
    patterns: [
        {offset: 0,
            repeat: 40,
            symbol: L.Symbol.arrowHead({pixelSize: 8, polygon: false, pathOptions: {color: '#000000', stroke: true, weight: 1.5, opacity: 0.5}})
        }
    ]
}).addTo(layer);



// Маркеры остановок
const stopMarker = (lat, lng, n) => {
    return new L.Marker([lat, lng], {
        icon: new L.DivIcon({
            className: 'stop-marker',
            html: '<span>'+n+'</span>'
        })
    });
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
