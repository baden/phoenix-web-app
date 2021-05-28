import './markers.css';


export const mIcon = (icon) => L.divIcon({
    className: 'custom-div-icon',
    html: `<div style='background-color:#66f;' class='marker-pin'></div><i class='material-icons'>${icon}</i>`,
    iconSize: [30, 42],
    iconAnchor: [15, 42]
});

export const iIcon = (icon) => L.divIcon({
    className: 'custom-div-icon',
    html: `<div style='background-color:#c30b82;' class='marker-pin'></div><span class=\"icon-${icon}_icon image-logo\"></span>`,
    iconSize: [30, 42],
    iconAnchor: [15, 42]
});

export default () => {
    mIcon, iIcon
};
