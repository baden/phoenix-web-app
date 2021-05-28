/* global  moment:true, d3:true */

import moment from 'moment';
import './eventmarker.css';

console.log("moment here", moment);

/* global angular:true, window:true, google:true, $:true, console:true */
// Новая реализация event-маркеров на leaflet

/*
Маркер событий трека.
Доступны маркеры:
1. Стоянок.
2. Остановок.
3. Заправки.
4. Сливы топлива.
5. Тревожные события.
...
*/

    const humanizeMiliseconds = (wtf) => {
        return $filter('humanizeMiliseconds')
    };

    const eventDuration = (d) => {
        // return moment(new Date((d.point.dt * 1000))).format('DD/MM/YYYY : hh:mm');;
        if (d.end && d.point) {
            var duration = (d.end.dt - d.point.dt);
            if (duration < 60) return 'меньше минуты';
            else return moment.duration(duration * 1000).humanize();
        } else {
            return '';
        }
    };


    const EventMarker = L.LayerGroup.extend({
        initialize: function(options) {
            // console.log("NewPointMarkers.initialize", options, this);
            L.LayerGroup.prototype.initialize.call(this);
            L.Util.setOptions(this, options);
            this.div = null;
        },
        destruct: function() {
            // console.log("NewPointMarkers.destruct", this);
        },
        onAdd: function (map) {
            console.log("NewEventMarkers.onAdd", map, this);
            this.map = map;
            this.data = this.data || [];

            // this.popup = L.popup();

            // HINT: Set closeOnClick: false is stopPropagation is not worked
            // this.popup = L.popup({autoPan: true, closeOnClick: false});
            this.popup = L.popup({autoPan: true, closeOnClick: true});
                // .setLatLng(L.latLng(48.370848, 32.717285))
                // .setContent('<p>Hello world!<br />This is a nice popup.</p>')
                // .openOn(map);

            var div =  L.DomUtil.create('div'); //
            // div.setAttribute('class', 'eventmarker');
            div.setAttribute('class', 'eventmarker leaflet-zoom-hide');
            div.setAttribute('style', 'z-index:1000');
            this.map.getPanes().shadowPane.appendChild(div);

            this.div = div;
            map.on('zoom', this.redraw, this);

            L.LayerGroup.prototype.onAdd.call(this, map);
        },
        redraw: function() {
            console.log("NewPointMarkers.redraw", this.data);
            var _map = this.map;
            var that = this;

            // var bounds = this.map.getBounds();
            // var size = this.map.getSize();
            // var top_left = this.map.latLngToLayerPoint(bounds.getNorthWest());
            // var svg = d3.select("#event-marker-overlay");
            // svg.style("width", size.x + "px")
            //     .style("height", size.y + "px")
            //     .style("left", top_left.x + "px")
            //     .style("top", top_left.y + "px");

    		var track = d3.select(this.div);
    		// track.attr("style", "transform: translate3d(" + (-top_left.x) + "px, " + (-top_left.y) + "px, 0px)");


            // Назначим индексы стоянкам
            var index = 0;
            for (var i = 0; i < this.data.length; i++) {
                var e = this.data[i];
                var title = '';
                if (e.type === 'START') {
                    title = 'S';
                } else if (e.type === 'FINISH') {
                    title = 'F';
                } else if (e.type === 'STOP') {
                    title = '' + index;
                    index += 1;
                } else {}
                e.title = title;
            }


            var points = track.selectAll('.track')
                .data(this.data);

            var div = points.enter().append('div')
                .attr('class', 'track')
                .attr('title', function(d) {
                    switch(d.type){
                        case 'HOLD': return 'Остановка: ' + eventDuration(d);
                        case 'STOP': return 'Стоянка: ' + eventDuration(d);
                        case 'START': return 'Начало трека';
                        case 'FINISH': return 'Конец трека';
                    }
                })
            // .attr('style', function(d){
            //     var px = overlayProjection.fromLatLngToDivPixel(d.pos);
            //     // console.log('d=', d, 'px=', px);
            //     return 'left: ' + (px.x) + 'px; top: ' + (px.y) + 'px';
            // })
            .on('click', function(d) {
                console.log('TODO', d3.select(this), d, point);

                var point = d.point;
                if(!d.point) return;
                // window.console.log('TODO', d3.select(this), d);
                // var timeStr = moment(new Date(point.dt * 1000)).format('DD/MM/YYYY HH:mm:ss');
                var start = moment(new Date(point.dt * 1000)).format('DD/MM/YYYY HH:mm:ss');
                var duration, stop;

                var lat = Math.round(point.lat * 100000) / 100000;
                var lon = Math.round(point.lon * 100000) / 100000;
                if(d.end) {
                    duration = ' ' + humanizeMiliseconds((d.end.dt - d.point.dt) * 1000);
                    stop = moment(new Date(d.end.dt * 1000)).format('DD/MM/YYYY HH:mm:ss');
                }
                // var sats = point.sats;
                // var speed = Math.round(point.speed * 10) / 10;
                // var vin = Math.round(point.vin * 100) / 100;
                // var vout = Math.round(point.vout * 100) / 100;
                var title;
                switch(d.type){
                    case 'HOLD': title = 'Остановка'; break;
                    case 'STOP': title = 'Стоянка'; break;
                    case 'START': title = 'Начало трека'; break;
                    case 'FINISH': title = 'Конец трека'; break;
                }
                var content =
                    '<h4 class="event-info-window">' + title + (duration?duration:'') + '</h4>' +
                    '<table class="point-info-window" width="100%"><tbody>' +
                        '<tr><td>' + (stop?'Начало':'Время') + ':</td><td>' + start + '</td></tr>' +
                        (stop?('<tr><td>Конец:</td><td>' + stop + '</td></tr>'):'') +
                        // (duration?('<tr><td>Продолжительность</td><td>' + duration + '</td></tr>'):'') +
                        '<tr><td>Долгота:</td><td>' + lat + '</td></tr>' +
                        '<tr><td>Широта:</td><td>' + lon + '</td></tr>' +
                    '</tbody></table>';
                // that.map.customInfoWindow.setContent(content);
                // that.map.customInfoWindow.setPosition(new L.LatLng(point.lat, point.lon));
                // that.map.customInfoWindow.open(that.map);

                that.popup
                    .setLatLng(new L.LatLng(point.lat, point.lon))
                    .setContent(content)
                    // .setContent('<p>Hello world!<br />This is a nice popup.</p>')
                    .openOn(that.map);

                Geocoder.geocode({'lat': lat, 'lon': lon})
                .then(function(address) {
                    console.log("Readress?");
                    that.popup.setContent(content + "<div class=\"popup_address\">" + address + "</div>");
                });

                d3.event.stopPropagation();

            });
            div.append('span').attr('class', 'eventmarker-number').text(function(d) {
                return d.title;
            });
            div.append('div').attr('class', 'eventmarker-nonumber').text('P');
            // var label = div.append('span').attr('class', 'title');

            // /*var label = div.append('div').attr('class', 'lastmarker-label').text(function(d) {
            //         return d.title;
            //     });*/
            // var control = label.append('div').attr('class', 'lastmarker-control');
            // var table = control.append('table').attr('id', function(d) {
            //     return 'eventMarkerID_' + d.point.course + d.point.dt;
            // });
            // var tbody = table.append('tbody');
            // //tbody = table.append('tbody');
            // var timeLine = tbody.append('tr');
            // timeLine.append('td').text(function(d) {
            //     return d.type == 'HOLD' ? 'Остановка:' : 'Стоянка:';
            // });
            // timeLine.append('td').text(function(d) {
            //     return eventDuration(d);
            // });

            points
                .attr('class', function(d) {
                    // if()
                    return 'track ' + d.type;
                })
                .attr('style', function(d) {
                    // var px = overlayProjection.fromLatLngToDivPixel(d.position);
                    var px = _map.latLngToLayerPoint(d.position);
                    // console.log('d=', d, 'px=', px);
                    return 'left: ' + (px ? px.x : 0) + 'px; top: ' + (px ? px.y : 0) + 'px;';
                });

            points.exit().remove();


                    // that.popup
                    //     .setLatLng(new L.LatLng(point.lat, point.lon))
                    //     .setContent(content)
                    //     // .setContent('<p>Hello world!<br />This is a nice popup.</p>')
                    //     .openOn(that.map);
                    //
                    // d3.event.stopPropagation();


        },

        hideInfo: function() {
            // console.log("NewPointMarkers.hideInfo (DEPRECATED?)", this);
        },
        setData: function(data) {
            console.log("NewPointMarkers.setData (DEPRECATED?)", data, this);
            this.data = data;
            setTimeout(() => {
                this.redraw();
            }, 500);
        }
    });

export default EventMarker;
