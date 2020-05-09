console.warn("Не нравится мне реализация HTML-логов Logs.port. Возможно стоит взять abinayasudhir/html-parser или что-то подобное.");


class LogLine extends HTMLElement {
    constructor() {
        super();

        new MutationObserver((mr) => this._stageElChange(mr))
          .observe(this, { attributes: true, attributeFilter: ["data-html"], attributeOldValue: true});

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
        // var container = document.createElement("div");
        var dataHtml = this.getAttribute('data-html');
        // console.log("dataHtml=", dataHtml);
        this.innerHTML = dataHtml || "...";
        // container.innerHTML = this._dataHtml || "...";
        // this.appendChild(container);
        // this._container = container;
    }

    disconnectedCallback() {
        // this[VIEW].disconnect();
    }

    _stageElChange(mutations) {
        const me = this;
        // console.log("mutation", mutations);
        mutations.forEach(function(m) {
            switch (m.attributeName) {
                case 'data-html':
                    var dataHtml = me.getAttribute('data-html');
                    me.innerHTML = dataHtml;
                    // console.log("mutation to", dataHtml);
                    break;
                default:
            };
        });
    }
}

window.customElements.define("baden-log-line", LogLine);
