import './main.css';
import { Elm } from './Main.elm';
import Map from './Map/leaflet-port.js';
import registerServiceWorker from './registerServiceWorker';
import "../node_modules/materialize-css/dist/css/materialize.css";
// import materialize from 'materialize';

const tokenKey = 'auth_token';

var app = Elm.Main.init({
  // node: document.getElementById('root'),
  //
  flags: {
      token: localStorage.getItem(tokenKey)
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
        console.log("onmessage", [message.data]);
        app.ports.websocketIn.send(message.data);
    }
    socket.onerror = (error) => {
        console.log("onerror", error.message);
    };
    socket.onclose = () => {
        console.log("onclose");
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


// app.ports.mapInit.subscribe(id => {
//     console.log('mapInit(', id, ')');
//     Map(id);
// });
