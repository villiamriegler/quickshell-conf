import QtQuick
import Quickshell
import Quickshell.Io
import Quickshell.Wayland

/**
 * Quickshell socket object
 *
 * @typedef {Object} QsSocket
 * @property {boolean} connected
 * @property {string} path
 * @property {() => void} flush
 * @property {(data: string) => void} write
 *
 * // Signal handler property (QML provides on<SignalName> handlers)
 * @property {((error: any) => void)} onError
 */

Item {
    id: root

    function init() {
        startEventStream();
    }

    function dumpModel(model, label = "model", max = 50) {
        console.log(`--- ${label}: count=${model.count} ---`);
        const n = Math.min(model.count, max);
        for (let i = 0; i < n; i++) {
            console.log(i, JSON.stringify(model.get(i)));
        }
    }

    /**
	 * Definition of Workspace type
	 *
	 * @typedef {Object} Workspace
	 * @property {number} id
	 * @property {number} idx
	 * @property {string | null} name
	 * @property {string | null} output
	 * @property {boolean} is_urgent
	 * @property {boolean} is_active
	 * @property {boolean} is_focused
	 * @property {number | null} active_window_id
 	*/
    property ListModel workspaces: ListModel {}
    signal workspacesUpdated

    /**
	 * Creates workspace from json data
	 */
    function createWorkspace(wd) {
        return {
            "id": wd.id,
            "idx": wd.idx,
            "name": wd.name || "",
            "output": wd.output || "",
            "is_urgent": wd.is_urgent,
            "is_active": wd.is_active,
            "is_focused": wd.is_focused,
            "active_window_id": wd.active_window_id
        };
    }

    /**
	 * Returns whether a workspace is occupied or not
	 */
    function workspaceOccupied(ws) {
        return ws.active_window_id ? true : false;
    }

    /**
	 * Sorts workspaces by output and index
	 */
    function sortWorkspaces(wss) {
        wss.sort((a, b) => {
            if (a.output !== b.output) {
                return a.output.localeCompare(b.output);
            }
            return a.idx - b.idx;
        });
        return wss;
    }

    /**
	 * Creates an intermediary list of workspaces from json data
	 * before replacing global reference
	 */
    function buildWorkspaces(wssd) {
        const processing_workspaces = [];
        for (const ws of wssd) {
            processing_workspaces.push(createWorkspace(ws));
        }
        return sortWorkspaces(processing_workspaces);
    }

    /**
	 * Update global workspaces reference
	 */
    function updateWorkspaces(wss) {
        workspaces.clear();
        for (const ws of wss) {
            workspaces.append(ws);
        }
        workspacesUpdated();
    }

    function handleWorkspaceChangedEvent(event) {
        if (event.WorkspacesChanged) {
            updateWorkspaces(buildWorkspaces(event.WorkspacesChanged.workspaces));
        }
    }

    /**
	 * Send a simple command to a qs socket
	 *
	 * @param {QsSocket} socket
	 * @param {Object} command
	 */
    function sendSocketCommand(socket, command) {
        socket.write(JSON.stringify(command) + '\n');
        socket.flush();
    }

    /*
	 * Niri event stream handling
	 */
    Socket {
        id: niriEventSocket
        path: Quickshell.env("NIRI_SOCKET")

        connected: false

        parser: SplitParser {
            onRead: data => {
                try {
                    const event = JSON.parse(data.trim());
                    root.handleEvent(event);
                } catch (e) {
                    console.error("NiriService", "Error parsing event stream", e);
                }
            }
        }
    }

    function startEventStream() {
        if (!niriEventSocket.connected) {
            niriEventSocket.connected = true;
        }
        sendSocketCommand(niriEventSocket, "EventStream");
    }

    function handleEvent(event) {
        handleWorkspaceChangedEvent(event);
    }
}
