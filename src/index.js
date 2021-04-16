import './main.css';
// import './style/style.css';
import { Elm } from './Main.elm';
import Map from './Map/leaflet-port.js';
import './Page/System/Logs/port.js';
import registerServiceWorker from './registerServiceWorker';

const LANGUAGE_KEY = 'fenix.language';
const THEME_KEY = 'fenix.theme';
const SCALE_KEY = 'fenix.scale';

// process.env.NODE_ENV == "development" || "production"
const env = process.env.NODE_ENV || 'development';

// TODO: Remove materialize.css
// import "../node_modules/materialize-css/dist/css/materialize.css";
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
// const choosed_endpoint = fx_api_endpoint;
const choosed_endpoint = (hostname=="localhost" || hostname=="fenix-ca60d.web.app") ? fx_api_endpoint : global_api_endpoint;

const theme_style = document.querySelector("#theme");
const scale_style = document.querySelector("#scale");

console.log("API endpoint: ", choosed_endpoint);

function devLog (name, arg) {
  if (env === 'development') {
    console.log('[dev]', name, arg)
  }
}


function getUserLanguage () {
  const urlParams = new URLSearchParams(window.location.search)

  return (
    urlParams.get('lang') ||
    window.localStorage.getItem(LANGUAGE_KEY) ||
    navigator.language ||
    navigator.userLanguage ||
    // 'en-US'
    'ru-RU'
  )
}


// Translations. Just for simple start. Maybe need refactoring later.

// const translations = await fetch('translations/en-US.json');
// console.log("translations", translations);
// console.log("languages", languages);

const flags = {
    token: localStorage.getItem(tokenKey),
    api_url: choosed_endpoint,
    language: getUserLanguage(),
    theme: getUserTheme(),
    scale: getScale()
}

console.log("Start app with flags:", flags);

var app = Elm.Main.init({flags});

registerServiceWorker();

let socket;

// console.log("app.ports", [app.ports]);

function open(url) {
    // console.log("open");
    socket = new WebSocket(url);
    socket.onopen = () => {
        // console.log("onopen");
        app.ports.websocketOpened.send(true);
    }
    socket.onmessage = message => {
        // console.log("onmessage", [message.data, JSON.parse(message.data)]);
        app.ports.websocketIn.send(message.data);
    }
    socket.onerror = (error) => {
        // console.log("onerror", error.message);
    };
    socket.onclose = () => {
        // console.log("onclose");
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
    console.log("websocketOut", JSON.stringify(message));
    if (socket && socket.readyState === 1) {
        socket.send(JSON.stringify(message));
    } else {
        console.log("sending canceled", [message, socket]);
    }
});


app.ports.saveToken.subscribe(token => {
    console.log('saveToken', token);
    if (token === null || token == "") {
    // if (token === null) {
        localStorage.removeItem(tokenKey);
        location.reload();
    } else {
        localStorage.setItem(tokenKey, token);
    }
});

app.ports.saveLanguage.subscribe(langCode => {
    console.log("Save language", langCode);
    localStorage.setItem(LANGUAGE_KEY, langCode);
});


// TODO: Не удалять следующие коментарии. Он в скором времени пригодятся.

function getUserTheme() {
    const urlParams = new URLSearchParams(window.location.search);

    const themeName = urlParams.get('theme') ||
        window.localStorage.getItem(THEME_KEY) ||
        defaultTheme();

    theme_style.href = "/css/style-" + themeName + ".css";

    return (themeName);
}

function defaultTheme() {
    if(preferredColorScheme().matches) {
        return "dark";
    } else {
        return "light"
    }
}

function getScale() {
    const scaleName =
        window.localStorage.getItem(SCALE_KEY) || "normal";
    scale_style.href = "/css/scale-" + scaleName + ".css";
    return scaleName;
}


// ---------
// Dark mode
// ---------
//
// Use in flags:
//
// {
//     darkMode: preferredColorScheme().matches
// }
//
function preferredColorScheme() {
  const m =
    window.matchMedia &&
    window.matchMedia("(prefers-color-scheme: dark)");

  // m && m.addEventListener && m.addEventListener("change", e => {
  //     console.log("Theme changed");
  //   app.ports.preferredColorSchemaChanged.send({ dark: e.matches })
  // })

  return m;
}

app.ports.saveTheme.subscribe(themeName => {
    console.log("Save theme", themeName);
    localStorage.setItem(THEME_KEY, themeName);
    theme_style.href = "/css/style-" + themeName + ".css";
});

app.ports.saveScale.subscribe(scaleName => {
    console.log("Save scale", scaleName);
    localStorage.setItem(SCALE_KEY, scaleName);
    scale_style.href = "/css/scale-" + scaleName + ".css";
});


// In ELM:
// port preferredColorSchemaChanged : ({ dark : Bool } -> msg) -> Sub msg



// ---------
// Clipboard
// ---------

app.ports.copyToClipboard.subscribe(copyToClipboard);

// wire.clipboard = () => {
//   app.ports.copyToClipboard.subscribe(copyToClipboard)
// }
//
//
function copyToClipboard(text) {
  // Insert a textarea element
  const el = document.createElement("textarea")

  el.value = text
  el.setAttribute("readonly", "")
  el.style.position = "absolute"
  el.style.left = "-9999px"

  document.body.appendChild(el)

  // Store original selection
  const selected = document.getSelection().rangeCount > 0
    ? document.getSelection().getRangeAt(0)
    : false

  // Select & copy the text
  el.select()
  document.execCommand("copy")

  // Remove textarea element
  document.body.removeChild(el)

  // Restore original selection
  if (selected) {
    document.getSelection().removeAllRanges()
    document.getSelection().addRange(selected)
  }

}







// app.ports.logger.subscribe(text => {
//     console.log(text);
// });


// app.ports.mapInit.subscribe(id => {
//     console.log('mapInit(', id, ')');
//     Map(id);
// });
