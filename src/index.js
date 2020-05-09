import './main.css';
import { Elm } from './Main.elm';
import Map from './Map/leaflet-port.js';
import './Page/System/Logs/port.js';
import registerServiceWorker from './registerServiceWorker';
import "../node_modules/materialize-css/dist/css/materialize.css";
// import fontawesome from '@fortawesome/fontawesome-free';
// import '@fortawesome/fontawesome-free';

const tokenKey = 'auth_token';

const hostname = location.hostname;
// const isSSH = location.protocol == "https:";
const protocol = location.hostname == "localhost" ? "wss:" : ((location.protocol == "https:") ? "wss:" : "ws:");

const api_path = "/api/v1/websocket";
const local_api_endpoint = protocol + "//localhost:8080" + api_path;
const global_api_endpoint = protocol + "//" + hostname + api_path;
const fx_api_endpoint = protocol + "//fx.navi.cc"  + api_path;
// const fx_api_endpoint = protocol + "//pil.fx.navi.cc"  + api_path;


// const choosed_endpoint = (hostname=="localhost") ? local_api_endpoint : global_api_endpoint;
// const choosed_endpoint = global_api_endpoint;
const choosed_endpoint = fx_api_endpoint;

console.log("API endpoint: ", choosed_endpoint);

var app = Elm.Main.init({
  // node: document.getElementById('root'),
  //
  flags: {
      token: localStorage.getItem(tokenKey),
      api_url: choosed_endpoint
  }
});

registerServiceWorker();

let socket;

console.log("app.ports", [app.ports]);

function open(url) {
    console.log("open");
    socket = new WebSocket(url);
    socket.onopen = () => {
        console.log("onopen");
        app.ports.websocketOpened.send(true);
    }
    socket.onmessage = message => {
        console.log("onmessage", [message.data, JSON.parse(message.data)]);
        app.ports.websocketIn.send(message.data);
    }
    socket.onerror = (error) => {
        console.log("onerror", error.message);
    };
    socket.onclose = () => {
        console.log("onclose");
        app.ports.websocketOpened.send(false);
        socket = null;
        setTimeout(function() {
            open(url);
        }, 1000);
    }
}

app.ports.websocketOpen.subscribe(url => {
    open(url);
});

app.ports.websocketOut.subscribe(message => {
    console.log("websocketOut", [message]);
    if (socket && socket.readyState === 1) {
        socket.send(JSON.stringify(message));
    } else {
        console.log("sending canceled", [message, socket]);
    }
});


app.ports.saveToken.subscribe(token => {
    console.log('saveToken', token);
    if (token === null) {
        localStorage.removeItem(tokenKey);
    } else {
        localStorage.setItem(tokenKey, token);
    }
});

// app.ports.logger.subscribe(text => {
//     console.log(text);
// });


// app.ports.mapInit.subscribe(id => {
//     console.log('mapInit(', id, ')');
//     Map(id);
// });
