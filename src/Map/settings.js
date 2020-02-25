export function MapSettings() {
    var CONFIG_NAME = 'leaflet.map.config';

    function Settings() {
        var prev_config = JSON.parse(window.localStorage.getItem(CONFIG_NAME) || "{}");
        // console.log("Restore map settings", prev_config);
        // console.log("prev_config.baseLayer = ", prev_config.baseLayer);


        var center = prev_config.center || [48.370848, 32.717285];
        this.center = L.latLng(center[0], center[1]) || L.latLng(48.370848, 32.717285);
        this.zoom = prev_config.zoom || 6;
        this.defaultLayer = "OpenStreetMap";
        this.baseLayer = prev_config.baseLayer || this.defaultLayer;

        // if (prev_config) {
        //     prev_config = JSON.parse(prev_config);
        // } else {
        //     prev_config = {
        //         zoom: 6,
        //         center: L.latLng(48.370848, 32.717285),
        //         typeId: google.maps.MapTypeId.ROADMAP
        //     };
        // }
    }

    Settings.prototype.save = function() {
        // console.log("Save map config", this);
        window.localStorage.setItem(CONFIG_NAME, JSON.stringify({
            center: [this.center.lat, this.center.lng],
            zoom: this.zoom,
            baseLayer: this.baseLayer
        }));
    };

    return new Settings();
}
