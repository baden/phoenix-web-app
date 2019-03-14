import './main.css';
import { Elm } from './Main.elm';
import registerServiceWorker from './registerServiceWorker';

var app = Elm.Main.init({
  node: document.getElementById('root')
});

registerServiceWorker();

let socket;

console.log("app.ports", [app.ports]);

app.ports.websocketOpen.subscribe(url => {
    socket = new WebSocket(url);
    socket.onopen = () => {
        console.log("onopen");
        app.ports.websocketOpened.send(true);
    }
    socket.onmessage = message => {
        console.log("onmessage", [message.data]);
        app.ports.websocketIn.send(message.data);
    }
});

app.ports.websocketOut.subscribe(message => {
    console.log("websocketOut", [message]);
    if (socket && socket.readyState === 1) {
        socket.send(JSON.stringify(message));
    }
});
