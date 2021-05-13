const http = require('http');
const fetch = require('node-fetch');
const fs = require('fs');
const {getCrc16} = require('./crc16');

const PIL_API_URL = "https://piligrim-gps.com/1.0";
const FX_POINT_URL = "http://point.fx.navi.cc";
// 868204007900656-1975
// 867793030924205
// 863586035135015

const IMEI = "353358016132230";

const btoa = (str) => Buffer.from(str).toString('base64');

const ACCESS_TOKEN = "acrIEpaFiGg77BxytJEbrNQ9UEuIHOSx";
const DEST_ACCESS_TOKEN = "acrIEpaFiGg77BxytJEbrNQ9UEuIHOSx";

const headers = (token) => { return {
    "Accept": "application/octet-stream"
    // "Bearer", token
}}

const geos_url = (imei, from, to) => {
    // Альтернативный вариант передачи токена -
    // access_token=${token}
    return `${PIL_API_URL}/geos/${btoa(imei)}?from=${from}&to=${to}&access_token=${ACCESS_TOKEN}`;
}

const DEST_IMEI = "867556046191915";
const dest_url = (imei) => `${FX_POINT_URL}/bingps?imei=${imei}&phone=123`;

console.log("point copier");
console.log("IMEI", btoa(IMEI));
console.log("geos_url", geos_url(IMEI, 450045, 450188));

const takeData = async (from, to) => {
    const response = await fetch(geos_url(IMEI, from, to), {headers: headers(ACCESS_TOKEN), compress:true});
    const body = await response.buffer();
    console.log("response", response);
    console.log("body length", body.length);

    console.log("Save backup to bak-test-point.bin");
    fs.writeFileSync("bak-test-point.bin", body, "binary");
    return body;
}

(async () => {



    const from = 450045;
    const to = 450188;
    const data = await takeData(from, to);
    console.log(`Redirect to ${dest_url(DEST_IMEI)}`);

    const crc = getCrc16(data);
    var crcbuf = new Buffer(2);
    crcbuf.writeUInt16LE(crc, 0);

    const response = await fetch(dest_url(DEST_IMEI), {
        method: 'POST',
        headers: {"Accept": "application/octet-stream"},
        body: Buffer.concat([data, crcbuf])
    });
    const body = await response.buffer();
    console.log("response", response);
    console.log("body length", body.length);
    console.log("body length", body.toString());




})();
