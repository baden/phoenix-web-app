const API_TOKEN = 'fenix_wip_token';

/* Константы */
var FSOURCE = {
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
var POINTTYPE = {
    UNKNOWN:        0,
    MOVE:           1,
    STOP:           2
};

const DEFAULT_OPTIONS = {
    raw: false,
    useServerFiltration: false,
    filter_shortTraveled: true,
    filter_invalidPoints: true,
    filter_ejection: true,
    filter_clearStopPoints: true,
    filter_shortStops: true,
    addPoint_23_59: true,
    addPoint_00_00: true,
    stopDistance: 1,
    stopTime: 3,
    minMoveDistance: 0.15,
    minMoveTime: 7,
    minTripPointsCount: 2,
    minStopTime: 8,
    interval_0: 60,
    interval_1: 120,
    interval_2: 180,
    motorOn_min: 13.1,
    motorOn_min_2: 26.2,
    motorOn_max: 19,
    stopMovingMinDistance: 0.01,
    stopMovingMinDistance_2: 0.02,
    moving_speed_with_out_accelerometer: 60,
    moving_a_distance_with_out_accelerometer: 1,
    moving_speed_with_accelerometer: 15,
    moving_a_distance_with_accelerometer: 0.05,
    moving_speed_with_motor_on: 5,
    moving_a_distance_with_motor_on: 0.03,
    // correctFromHours: 120,
    correctFromHours: 0,
    minSputniksCount: 4, //если меньше то удалить точку
    ejectionDistance: 0.5,
    ejectionTime: 1200,
    ejectionMultiplier: 2
    // updateValues: (sys) => {
    //     if (system && system.car) {
    //         for(var key in this) {
    //             if (key in sys.car)
    //                 if (sys.car [key] !== '') {
    //                     if (sys.car [key] == 'true')
    //                         this [key] = true;
    //                     else if (sys.car [key] == 'false') {
    //                         this [key] = false;
    //                     } else if (typeof(sys.car [key]) == 'string') {
    //                         //console.log("value is string! key : ", key, " Value : ", sys.car [key]);
    //                         this [key] = parseFloat(sys.car [key].replace(",", "."));
    //                     } else {
    //                         this [key] = sys.car [key];
    //                     }
    //                 }
    //         }
    //         // console.log ("updateValues-------> options : ", options);
    //     }
    // }
};

const parserF5 = (packet, offset) => {
    var lat = packet.getInt32(offset + 8, true) / 600000.0;         // latitude,               # I: Широта 1/10000 минут
    var lon = packet.getInt32(offset + 12, true) / 600000.0;        // longitude,              # I: Долгота 1/10000 минут
    // console.log("lat=", lat, "lon=", lon);

    if ((Math.abs(lat) >= 90) || (Math.abs(lon) >= 180)) {
        //console.log('skip', new Date(dt*1000), lat, lon, fsource);
        return {size: 32, data: null};
    }
    var altitude = packet.getInt16(offset + 18, true);             // altitude,               # H: Высота над уровнем моря (м)
    if(packet.getUint8(offset + 19) > 127) altitude = altitude - 65536;

    var lsbs = packet.getUint8(offset + 25);                        // 0,                      # B: Младшие биты полей: vout, vin, adc1, adc2

    return {size: 32, data: {
        'fsource': packet.getUint8(offset + 2),                     // fsource,                # B: Тип точки   Причина фиксации точки
        'sats': packet.getUint8(offset + 3),                        // sats,                   # B: Кол-во спутников 3..12
        'dt': packet.getUint32(offset + 4, true),                   // dt,                     # I: Дата+время
        'lat': lat,
        'lon': lon,
        'speed': packet.getUint16(offset + 16, true) * 1.852 / 100,  // speed,                  # H: Скорость 1/100 узла
        'course': packet.getUint8(offset + 20) * 2,                  // int(round(course/2)),   # B: Направление/2 = 0..179
        'vout': (packet.getUint8(offset + 21) * 4 + (lsbs & 3)) / 10.0,            // vout,                   # B: Напряжение внешнего питания 1/100 B
        'vin': (packet.getUint8(offset + 22) * 4 + ((lsbs >> 2) & 3)) / 100.0,             // vin,                    # B: Напряжение внутреннего аккумулятора 1/100 B
        'altitude': altitude,
        'fuel': packet.getUint8(offset + 24) * 4 + ((lsbs >> 6) & 3),                   // adc2,                   # B: АЦП2 - уровень топлива
        'adc1': packet.getUint8(offset + 23) * 4 + ((lsbs >> 4) & 3),               // adc1,                   # B: АЦП1 - температура
        'lcrc': packet.getUint8(offset + 31)                            //# D15: Локальная CRC (пока не используется)
    }};
};

const parsers = {
    0xF5: parserF5
}

const parse_onebin = (packet, offset) => {
    var fsource, dt, lat, lon, speed, course, sats, vout, vin, flags, reserve1, reserve2, lcrc, adc1, adc2, lsbs, altitude;
    if (packet.getUint8(offset + 0) !== 0xFF) return {size: 1, data: null};
    var ptype = packet.getUint8(offset + 1);
    if(!parsers[ptype]) return {size: 1, data: null};
    // console.log("start parser", ptype);
    return parsers[ptype](packet, offset);
};

// Возвращает true если точка относится к стоянке
const isStop = (point, options) => {
    if (options.useServerFiltration && !options.raw) {
        return point.type === POINTTYPE.STOP;
    } else {
        return [FSOURCE.STOPACC, FSOURCE.TIMESTOPACC, FSOURCE.TIMESTOP, FSOURCE.SLOW].includes(point.fsource);
    }
};

const isStop_2 = (point) => {
    return point.type === POINTTYPE.STOP;
};

const isStop_fsource = (fsource) => {
    return $.inArray(fsource, [FSOURCE.STOPACC, FSOURCE.TIMESTOPACC, FSOURCE.TIMESTOP, FSOURCE.SLOW]) >= 0;
};



function checkStatus(response) {
  if (!response.ok) {
    throw new Error(`HTTP ${response.status} - ${response.statusText}`);
  }
  return response;
}

const bingpsparse_2 = (array, hoursFrom, options) => {
    console.log("bingpsparse_2", array, hoursFrom, options);
    var points = [];

    var array_length = array.byteLength;
    var i = 0;
    while(i < array_length) {
        var parce = parse_onebin(array, i);
        i += parce.size;
        var point = parce.data;
        if (point) {
            points.push(point);
        }
    }
    // console.log ("points : ", points);
    if (points.length === 0) {
        return {};
    }
    //////  добавить точку в конец трека с временем 23:59:59 если выбран не текущий день
    if (options.addPoint_23_59) {
        var addP = points [points.length - 1];
        var date = new Date();
        var tz = (date).getTimezoneOffset() / 60;
        var day = (new Date (addP.dt * 1000).valueOf() / 1000 / 3600) / 24;
        var dayNow = date.valueOf() / 1000 / 3600 / 24;
        if (Math.floor(day) != Math.floor(dayNow)) {
            var oldValue = addP.dt;
            var newValue = ~~(addP.dt / 3600);
            newValue = ~~(newValue / 24);
            newValue = (newValue * 24 + tz + 23) * 3600 + 3599;
            addP.dt = newValue;
            if (newValue < (oldValue + 3600)) {
                points.push (addP);
            }
        }
    }
    ///////
    if (options.useServerFiltration) {
        identifyPointsType (points);
        // console.log("after: useServerFiltration", points);
    }
    if (options.filter_invalidPoints)
        points = removeInvalidPoints (points, options);
        // console.log("after: filter_invalidPoints", points);
    if (options.filter_shortStops)
        points = removeShortStops (points, options);
        // console.log("after: filter_shortStops", points);
    if (options.filter_clearStopPoints)
        clearStopPointsCoordinates (points, options);
        // console.log("after: filter_clearStopPoints", points);
    if (options.filter_shortTraveled)
        points = removeShortTrips (points, options);
        // console.log("after: filter_shortTraveled", points);
    if (options.correctFromHours > 0)
        points = transferStopPoint (points, hoursFrom, options);
        // console.log("after: correctFromHours", points);
    if (options.filter_ejection)
        points = removeLargeMoveInShortTime (points, options);
        // console.log("after: filter_ejection", points);

    // updatePointsFuel (points);
    /*for (var j = 0; j < points.length; j++) {
        console.log ("point is stop : ", isStop(points [j]));
    }*/

    var events = getEventsFromPoints (points, 0, points.length, options);
    var bounds = getBoundsFromPoints (points, 0, points.length);
    var track = getTrackFromPoints (points, 0, points.length);
    var ranges = getRangesFromPoints (points, 0, points.length, options);
    var hours = getHoursFromPoints (points, 0, points.length);
    var ret = {
        track: track,
        bounds: bounds,
        points: points,
        min_hour: hours.min || 0,
        max_hour: hours.max || 1e15,
        hours: hours,
        events: events,
        // events: "TDB",
        ranges: ranges
    };
    // console.log ("track : ", ret);
    return ret;
}

const bingpsparse = (array, hoursFrom, options) => {
    const offset = 0;
    console.log('parse', array);
    var track = [];
    var points = [];
    var events = []; // События на треке: Старт, стоп, стоянки (момент), остановки (момент), заправки и т.д.
    var ranges = []; // Интервалы: Движение, стоянка, остановка
    var bounds = null;
    var min_hour = 1e15;
    var max_hour = 0;
    var hours = {};
    var range_start;
    var stop_start = null; // Точка начала стоянки/остановки
    var move_start = null; // Точка начала движения
    var firstHour = hoursFrom;
    var lastStopPoint = null;
    var lastStopgPoint = null;
    var prevPointIsStop = false;
    var cleared = false;

    var index = 0;

    var fuelscale = System.$fuelscale(skey);
    var prevpoint = null;
    var array_length = array.byteLength;
    var i = 0;
    while(i < array_length) {
        var parce = parse_onebin(array, i);
        i += parce.size;
        var point = parce.data;
        //var point = parse_onebin(array.subarray(i, i + 32));
        if(point !== null && point.fuel) {
            point.fuel = fuelscale(point.fuel);
        }
        if (point) {
            if(prevpoint && (point.dt <= prevpoint.dt)) {
                // console.log('revert', point, prevpoint, new Date(point.dt * 1000));
                continue;
            }
            var gpoint = new L.LatLng(point.lat, point.lon);
            var hour = ~~ (point.dt / 3600);
            if(!options.raw){// этот блок находит координату последней стоянки и позаоляет перенести координаты стоянки на следующие сутки (подразумевается что запрос бинарных данных был сделан с учетом предыдущих correctFromHours часов)
                //if (firstHour === null)
                    //firstHour = hour;
                if (!cleared && hour > firstHour + offset) {
                    //console.log ('clear pev ' + correctFromHours + ' hours');
                    cleared = true;
                    if (prevPointIsStop) {
                        gpoint = lastStopgPoint;
                        point.lat = lastStopPoint.lat;
                        point.lon = lastStopPoint.lon;
                        point.dt = hour * 3600;
                        //i -= 32;
                    }
                } else if (!cleared) {
                    if (isStop (point, options)) {
                         if (!prevPointIsStop) {
                             prevPointIsStop = true;
                             lastStopgPoint = gpoint;
                             lastStopPoint = point;
                         }
                    } else {
                        prevPointIsStop = false;
                    }
                    continue;
                }
            }
            prevpoint = point;
            // if(prevpoint){
            //     var d = distance(point, prevpoint);
            //     if(d > 4.0){
            //         window.console.log(d, new Date(point.dt * 1000));
            //         continue;
            //     }
            // }
            // prevpoint = point;

            if (bounds === null) {
                bounds = new L.LatLngBounds(gpoint, gpoint);
            } else {
                bounds.extend(gpoint);
            }

            points.push(point);

            if (hour < min_hour) min_hour = hour;
            if (hour > max_hour) max_hour = hour;
            hours[hour] = (hours[hour] || 0) + 1;

            if (events.length === 0) { // Первая точка
                events.push({
                    point: point,
                    position: gpoint,
                    type: 'START',
                    index: index
                });
                range_start = point;

                if (isStop(point)) {
                    stop_start = 0;
                    events.push({
                        point: point,
                        position: gpoint,
                        type: 'STOP', // Стоянка/остановка (тит пока не определен)
                        index: index
                    });
                } else {
                    move_start = 0;
                }
            }
            if (isStop(point)) {
                if (stop_start === null) {
                    stop_start = index;
                    events.push({
                        point: point,
                        position: gpoint,
                        type: 'STOP', // Стоянка/остановка (тит пока не определен)
                        index: index
                    });
                } else {
                    gpoint = new L.LatLng(points[stop_start].lat, points[stop_start].lon);
                }
                if (move_start !== null) {
                    ranges.push({
                        type: 'MOVE', // Движение
                        start_index: move_start,
                        start: points[move_start],
                        stop_index: index,
                        stop: points[index]
                    });
                    move_start = null;
                }
                // Уберем фантомные точки в стоянке
                if(!options.raw){
                    points[points.length-1].lat = points[stop_start].lat;
                    points[points.length-1].lon = points[stop_start].lon;
                }
            } else /*if(point['fsource'] === FSOURCE_START)*/ {
                if (stop_start !== null) {
                    var lastevent = events[events.length - 1];
                    lastevent.end = point;
                    if (lastevent.type === 'STOP') {
                        // var system = System.cached(skey);
                        // TODO: Убрана возможность задания времени стоянки
                        var treshold = 5;
                        // if (system && system.car && system.car.stop) {
                        //     treshold = system.car.stop | 0;
                        // }
                        var duration = lastevent.end.dt - lastevent.point.dt;
                        if (duration < treshold * 60) {
                            lastevent.type = 'HOLD';
                        }
                    }
                    ranges.push({
                        type: 'STOP', // Стоянка/остановка (тит пока не определен)
                        start_index: stop_start,
                        start: points[stop_start],
                        stop_index: index,
                        stop: points[index]
                    });
                    stop_start = null;
                }
                if (move_start === null) {
                    move_start = index;
                }
            }
            /* else {
        stop_start = null;
        if(!move_start){
            move_start = index;
        }
    }*/
            if(point.lat && point.lat !== 0){
                track.push(gpoint);
            }

            index += 1;
        }
    }

    if (index > 0) {
        events.push({
            point: points[index - 1],
            position: track[index - 1],
            type: 'FINISH',
            index: index - 1
        });
        if (stop_start !== null) {
            ranges.push({
                type: 'STOP', // Стоянка/остановка (тит пока не определен)
                start_index: stop_start,
                start: points[stop_start],
                stop_index: index - 1,
                stop: points[index - 1]
            });
        } else if (move_start !== null) {
            ranges.push({
                type: 'MOVE', // Движение
                start_index: move_start,
                start: points[move_start],
                stop_index: index - 1,
                stop: points[index - 1]
            });
        }
    }
    //console.log ("points.length : ", points.length);
    // for(var i = 0; i < ranges.length; i++){
    //     var r = ranges[i];
    //     r.start = points[r.start_index];
    //     r.stop = points[r.stop_index];
    // }

    return {
        track: track,
        bounds: bounds,
        points: points,
        min_hour: min_hour,
        max_hour: max_hour,
        hours: hours,
        events: events,
        ranges: ranges
    };
}



const getEventsFromPoints =  (points, startIndex, stopIndex, options) => {
    var events = [];
    if (points) {
        if (!startIndex)
            startIndex = 0;
        if (!stopIndex)
            stopIndex = points.length;
        var gpoint;
        var point = null;
        var stop_start = null;
        var stopTime = options.stopTime * 60;
        for (var i = startIndex; i < stopIndex; i++) {
            point = points [i];
            if (events.length === 0) { // Первая точка
                events.push({
                    point: point,
                    position: new L.LatLng(point.lat, point.lon),
                    type: 'START',
                    index: i
                });
            }
            if (isStop(point, options)) {
                if (stop_start === null) {
                    stop_start = i;
                    events.push({
                        point: point,
                        position: new L.LatLng(points[stop_start].lat, points[stop_start].lon),
                        type: 'STOP', // Стоянка/остановка (тит пока не определен)
                        index: i
                    });
                }
            } else {
                if (stop_start !== null) {
                    var lastevent = events [events.length - 1];
                    lastevent.end = point;
                    if (lastevent.type === 'STOP') {
                        var duration = lastevent.end.dt - lastevent.point.dt;
                        if (duration < stopTime) {
                            lastevent.type = 'HOLD';
                        }
                    }
                }
                stop_start = null;
            }
        }
        if (events.length > 0) {

            events.push({
                point: point,
                position: new L.LatLng(point.lat, point.lon),
                type: 'FINISH',
                index: stopIndex - 1
            });
        }
    }
    return events;
};


const removeInvalidPoints = (points, options) => {
    var points_ret = [];
    var i = 0;
    var prevPoint = null;
    for (; i < points.length; i++) {
        var point = points [i];
        if (point.lat === 0 && point.lon === 0) {
            //console.log ("Точка с координатами 0,0");
            continue;
        }
        if (!point.sats || point.sats < options.minSputniksCount) {
            //console.log("Маленькое количество спутников : ", point.sats);
            continue;
        }
        if (prevPoint !== null && point.dt - prevPoint.dt <= 0) {
            //console.log("Нарушение хронологии");
            continue;
        }
            prevPoint = point;
        points_ret.push (point);
    }
    return points_ret;
};


const removeShortStops = (points, options) => {
    var minStopTime = options.minStopTime;
    var points_ret = [];
    var stop_start = null;
    var insertPoints = function (start_index, stop_index, setFsource) {
        for (var j = start_index; j < stop_index; j++) {
            if (setFsource) {
                points [j].fsource = setFsource;
            }
            points_ret.push (points [j]);
        }
    };
    for (var i = 0; i < points.length; i++) {
        if (isStop (points [i], options)) {
            if (stop_start === null)
                stop_start = i;
        } else {
            if (stop_start !== null) {
                var stopTime = points [i].dt - points [stop_start].dt;
                if (stopTime > minStopTime) {
                    insertPoints (stop_start, i);
                } else {
                    insertPoints (stop_start, i, FSOURCE.TIMEMOVE);
                    //var newPoint = points [stop_start];
                    //var typePoint_index = (stop_start > 0) ? stop_start - 1 : i;
                    //copyPointType (points [typePoint_index], newPoint);
                    //points_ret.push (newPoint);
                }
                stop_start = null;
            }
            points_ret.push (points [i]);
        }
    }
    if (stop_start !== null) {
        insertPoints (stop_start, points.length);
    }

    return points_ret;
};

const removeShortTrips = (points, options) => {
    var minTripTime = options.minMoveTime;
    var minTripDistance = options.minMoveDistance;
    var minTripPointsCount = options.minTripPointsCount;
    var minMoveDistance = minTripDistance / 10;
    var tripFactor = 0.4;
    var minStopTime = options.stopTime * 60;
    var points_ret = [];
    var move_start = null;
    var stop_end = null;
    var stop_start = null;
    var prevStopTime = null;
    var lastInsertPointIndex = 0;
    var i = 0;
    var insertPoints = function (pointIndex) {
        for (var j = lastInsertPointIndex; j < pointIndex; j++) {
            points_ret.push (points [j]);
        }
        lastInsertPointIndex = pointIndex;
    };
    for (; i < points.length; i++) {
        var point = points [i];
        if (!isStop (point, options)) {
            if (move_start === null) {
                insertPoints (i);
                move_start = i;
                if (stop_start !== null) {
                    prevStopTime = point.dt - points [stop_start].dt;
                    stop_end = i - 1;
                } else {
                    stop_end = null;
                }
            }
        } else {
            if (stop_start === null) {
                stop_start = i;
                prevStopTime = null;
            }
            if (move_start !== null) {
                var tripDistance = 0;
                var pointsCount = 0;
                var maxDistance = 0;
                var nextStopTime = 0;
                var nextMoveStartIndex = i;
                for (var s = i; s < points.length; s++) {
                    nextStopTime = points [s].dt;
                    nextMoveStartIndex = s;
                    if (!isStop (points [s], options)) {
                        break;
                    }
                }
                nextStopTime = nextStopTime - point.dt;
                var startPointIndex = (stop_end !== null) ? stop_end : move_start;
                var startPoint = (stop_end !== null) ? points [stop_end] : points [move_start];
                pointsCount = i - move_start;
                stop_end = null;
                stop_start = null;
                for (var k = startPointIndex; k < i; k++) {
                    var d = distance (startPoint, points [k + 1]);
                    if (d > maxDistance)
                        maxDistance = d;
                    tripDistance += distance (points [k], points [k + 1]);
                }

                var dist = distance (startPoint, points [i]);
                var distToNextMove = distance (startPoint, points [nextMoveStartIndex]);
                //var condition_1 = minTripTime < (point.dt - points [move_start].dt);
                var condition_2 = minTripPointsCount <= pointsCount;
                //var condition_3 = (tripDistance / 2 < dist || minTripDistance < tripDistance);
                //var condition_4 = (minTripDistance < tripDistance && minMoveDistance < dist) || (((tripDistance * 0.6) < dist) && minMoveDistance < dist);
                //var condition_5 = !(distToNextMove < dist && tripDistance > minTripDistance && distToNextMove < minTripDistance * tripFactor);
                //var condition_6 = !(prevStopTime * 0.5 > minStopTime && nextStopTime * 0.5 > minStopTime && (tripDistance * 0.8) < minTripDistance);
                //var condition_7 = !(prevStopTime * 0.5 > minStopTime && nextStopTime * 0.5 > minStopTime && minTripPointsCount * 5 > pointsCount);

                if (//condition_1 &&
                    condition_2 &&
                    //condition_3 &&
                    //condition_4 &&
                    //condition_5 &&
                    //condition_6 &&
                    //condition_7 &&
                    true
                   ) {
                    insertPoints (i);
                } else {
                    //console.log ("1 : ", condition_1, " 2 : ", condition_2, " 3 : ", condition_3, " 4 : ", condition_4, " 5 : ", condition_5);
                    lastInsertPointIndex = i + 1;
                    var prevPoint = points_ret [points_ret.length - 1] || points [i];
                    var newPoint = points [i]; // TODO: deep Copy
                    //copyPointParams (prevPoint, newPoint);
                    newPoint.dt =  points [i].dt;
                    newPoint.type = point.type;
                    points_ret.push (newPoint);
                    //points_ret.push (point);
                }
                move_start = null;
            } else {
                insertPoints (i);
            }
        }
    }
    if (lastInsertPointIndex < points.length) {
        insertPoints (points.length);
    }
    return points_ret;
};



const clearStopPointsCoordinates =  (points, options) => {
    var stop_start = null;
    for (var i = 0; i < points.length; i++) {
        var point = points [i];
        if (isStop  (point, options)) {
            if (stop_start === null) {
                stop_start = i;
            } else {
                if (distance (points [stop_start], point) < options.stopDistance || i === points.length - 1) {
                    copyPointParams (points [stop_start], point);
                } else {
                    if (distance (points [i + 1], point) < options.stopDistance) {
                        stop_start = i;
                    } else {
                        copyPointParams (points [stop_start], point);
                    }
                }
            }
        } else {
            stop_start = null;
        }
    }
};

const transferStopPoint =  (points, hoursFrom, options) => {
    console.log("transferStopPoint", points, hoursFrom, options);
    let i = 0;
    var stopPoint = null;
    for (; i < points.length; i++) {
            var hour = ~~ (points [i].dt / 3600);
            if (hour >= hoursFrom + options.correctFromHours) {
                if (stopPoint !== null) {
                    if (distance (stopPoint, points [i]) < options.stopDistance) {
                        copyPointParams (stopPoint, points [i], options);
                    }
                    if (options.addPoint_00_00) {
                        points [i].dt = hour * 3600;
                    }
                }
                break;
            } else {
                if (isStop (points [i], options)) {
                     if (stopPoint === null) {
                         stopPoint = points [i];
                     }
                } else {
                    stopPoint = null;
                }
            }
    }
    return getPointsFromPoints (points, i, points.length);
};

const getPointsFromPoints = (points, startIndex, stopIndex) => {
    var ret_points = [];
    if (points) {
        if (!startIndex)
            startIndex = 0;
        if (!stopIndex)
            stopIndex = points.length;
        for (var i = startIndex; i < stopIndex; i++) {
            ret_points.push (points [i]);
        }
    }
    return ret_points;
};

const setPointType = (point, type) => {
    point.type = type;
};

const copyPointParams = (pointFrom, pointTo) => {
    pointTo.lat = pointFrom.lat;
    pointTo.lon = pointFrom.lon;
};

const distance = function(p1, p2) {
    var R = 6371; // km (change this constant to get miles)
    var dLat = (p2.lat - p1.lat) * Math.PI / 180;
    var dLon = (p2.lon - p1.lon) * Math.PI / 180;
    var a = Math.sin(dLat / 2) * Math.sin(dLat / 2) +
        Math.cos(p1.lat * Math.PI / 180) * Math.cos(p2.lat * Math.PI / 180) *
        Math.sin(dLon / 2) * Math.sin(dLon / 2);
    var c = 2 * Math.atan2(Math.sqrt(a), Math.sqrt(1 - a));
    var d = R * c;
    return d;
};


const removeLargeMoveInShortTime = function (points, options) {
    if (!points || points.length === 0)
        return [];
    var points_ret = [];
    var ejection = null;
    var ejectionDistance = options.ejectionDistance;
    var ejectionTime = options.ejectionTime;
    var ejectionMultiplier = options.ejectionMultiplier;

    points_ret.push (points [0]);
    for (var i = 0; i < points.length - 1; i++) {
        if (ejection !== null) {
            if (distance (ejection, points [i + 1]) < ejectionDistance)  {
                continue;
            } else {
                ejection = null;
                continue;
            }
        } else {
            var time = points [i + 1].dt - points [i].dt;
            var maxMovedDistance = (points [i].speed + points [i + 1].speed) * ejectionMultiplier * (time / 3600);
            var dist = distance (points [i], points [i + 1]);
            //if (distance (points [i], points [i + 1]) > ejectionDistance && ((points [i + 1].dt - points [i].dt) < ejectionTime)) {
            if (dist > maxMovedDistance && time < ejectionTime && dist > ejectionDistance) {
                ejection = points [i + 1];
                continue;
            }
        }
        points_ret.push (points [i + 1]);
    }
    return points_ret;
};


const getBoundsFromPoints = function (points, startIndex, stopIndex) {
    var bounds = null;
    if (points) {
        if (!startIndex)
            startIndex = 0;
        if (!stopIndex)
            stopIndex = points.length;
        for (var i = startIndex; i < stopIndex; i++) {
            var gpoint = new L.LatLng (points [i].lat, points [i].lon);
            if (bounds === null) {
                bounds = L.latLngBounds (gpoint, gpoint);
            } else {
                bounds.extend (gpoint);
            }
        }
    }
    return bounds;
};

const getTrackFromPoints = function (points, startIndex, stopIndex) {
    var track = [];
    // console.log("getTrackFromPoints", points, startIndex, stopIndex);
    if (points) {
        if (!startIndex)
            startIndex = 0;
        if (!stopIndex)
            stopIndex = points.length;
        for (var i = startIndex; i < stopIndex; i++) {
            //if (!isStop (points [i]))
            if(points [i].lat && (points [i].lat !== 0.0)){
                // console.log('points [i].lat=', points [i].lat);
                track.push (new L.LatLng (points [i].lat, points [i].lon));
            }
        }
    }
    return track;
};


const getRangesFromPoints = function (points, startIndex, stopIndex, options) {
    var ranges = [];
    if (points) {
        if (!startIndex)
            startIndex = 0;
        if (!stopIndex)
            stopIndex = points.length;
        var stop_start = null;
        var move_start = null;
        var i = startIndex;
        for (; i < stopIndex; i++) {
            var point = points [i];
            if (isStop (point, options)) {
                if (stop_start === null) {
                    stop_start = i;
                }
                if (move_start !== null) {
                    ranges.push({
                        type: 'MOVE', // Движение
                        start_index: move_start,
                        start: points [move_start],
                        stop_index: i,
                        stop: points [i]
                    });
                    move_start = null;
                }
            } else {
                if (move_start === null) {
                    move_start = i;
                }
                if (stop_start !== null) {
                    ranges.push({
                        type: 'STOP', // Остановка
                        start_index: stop_start,
                        start: points [stop_start],
                        stop_index: i,
                        stop: points [i]
                    });
                    stop_start = null;
                }
            }
        }
        if (stop_start !== null) {
            ranges.push({
                type: 'STOP', // Остановка
                start_index: stop_start,
                start: points [stop_start],
                stop_index: i - 1,
                stop: points [i - 1]
            });
            stop_start = null;
        }
        if (move_start !== null) {
            ranges.push({
                type: 'MOVE', // Движение
                start_index: move_start,
                start: points [move_start],
                stop_index: i - 1,
                stop: points [i - 1]
            });
            move_start = null;
        }
    }
    return ranges;
};


const getHoursFromPoints = function (points, startIndex, stopIndex) {
    var hours = {};
    var min_hour = 1e15;
    var max_hour = 0;
    if (points) {
        if (!startIndex)
            startIndex = 0;
        if (!stopIndex)
            stopIndex = points.length;
        for (var i = startIndex; i < stopIndex; i++) {
            var hour = ~~ (points [i].dt / 3600);
            if (hour < min_hour) min_hour = hour;
            if (hour > max_hour) max_hour = hour;
            hours[hour] = (hours[hour] || 0) + 1;
        }
    }
    hours.min = min_hour;
    hours.max = max_hour;
    return hours;
};



export function gps(sysId, from, to, options_) {
    const url = `http://pil.fx.navi.cc/1.0/geos/${sysId}?from=${from}&to=${to}&access_token=${API_TOKEN}`;
    const options = options_ || DEFAULT_OPTIONS;
    console.log("gps", sysId, from, to);

    return new Promise((resolve, reject) => {
        // TODO: Это как-то можно проще записать.
        fetch(url, {headers: {"Accept": "application/octet-stream"}, compress:true})
            // .then(response => checkStatus(response) && response.arrayBuffer())
            .then(response => checkStatus(response) && response.arrayBuffer())
            .then((res) => {
                const data_view = new DataView(res);
                // console.log("fetch done", res);
                // console.log("fetch done", data_view, options);
                const parsed = (options.raw) ? bingpsparse(data_view, from, options) : bingpsparse_2(data_view, from, options);
                // console.log("parsed=", parsed);
                resolve(parsed);
            });

    });

}

export default gps;
