pragma Singleton

import QtQuick
import Quickshell
import Quickshell.Io
import "utils.js" as Utils

Singleton {
    id: root
    property int _seq: 0

    signal eventEmitted(var event)

    /**
	 * Opens a connection to the NIRI_SOCKET and begins listening
	 * to the event stream (https://docs.rs/niri-ipc/25.11.0/niri_ipc/enum.Request.html#variant.EventStream)
	 */
    function init() {
        if (!niriEventSocket.connected) {
            niriEventSocket.connected = true;
        	Utils.sendSocketCommand(niriEventSocket, "EventStream");
        }
    }

    /**
	 * Normalizes the event data into an object of
	 *
	 * {kind: EventKind, payload: Data, ts: Date, seq: int}
	 */
    function _nomalizeEvent(raw) {
        const keys = Object.keys(raw);
        if (keys.length === 1) {
            const kind = keys[0];
            const payload = raw[kind];
            return {
                kind,
                payload,
                ts: Date.now(),
                seq: _seq++
            };
        }
        return {
            kind: "Unknown",
            raw,
            ts: Date.now(),
            seq: _seq++
        };
    }

    Socket {
        id: niriEventSocket
        path: Quickshell.env("NIRI_SOCKET")

        connected: false

        parser: SplitParser {
            onRead: data => {
                try {
                    const raw = JSON.parse(data.trim());
                    const event = root._nomalizeEvent(raw);
                    root.eventEmitted(event);
                } catch (e) {
                    console.error("Niri(EventStreamListener)", "Error parsing event stream", JSON.stringify(e));
                }
            }
        }
    }
}
