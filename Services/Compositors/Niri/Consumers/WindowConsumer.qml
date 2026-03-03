import QtQuick
import qs.Services.Compositors.Niri.Ipc

Item {
    id: root
    property var listener: EventStreamListener
    property ListModel windows: ListModel {}
    property var _idToIdx: ({})

	signal windowsUpdated

    function getWindowIndex(windowId) {
        const idx = _idToIdx[windowId];
        return idx !== undefined ? idx : -1;
    }

    function _canonLayoutData(raw) {
        return {
            pos_in_scrolling_layout: raw.pos_in_scrolling_layout ?? -1,
            tile_size: raw.tile_size,
            window_size: raw.window_size,
            tile_pos_in_workspace_view: raw.tile_pos_in_workspace_view ?? -1,
            window_offset_in_tile: raw.window_offset_in_tile
        };
    }

    function _canonFocusTimestampData(raw) {
        return {
            secs: raw?.secs ?? -1,
            nanos: raw?.nanos ?? -1
        };
    }

    function _canonWindowData(raw) {
		const timestamp = _canonFocusTimestampData(raw.focus_timestamp);
		const layout = _canonLayoutData(raw.layout);
        return {
            id: raw.id,
            title: raw.title ?? "",
            app_id: raw.app_id ?? "",
            pid: raw.pid ?? -1,
            workspace_id: raw.workspace_id ?? -1,
            is_focused: raw.is_focused,
            is_floating: raw.is_floating,
            is_urgent: raw.is_urgent,
			focus_secs: timestamp.secs,
			focus_nanos: timestamp.nanos,
            pos_in_scrolling_layout: layout.pos_in_scrolling_layout,
            tile_size: layout.tile_size,
            window_size: layout.window_size,
            tile_pos_in_workspace_view: layout.tile_pos_in_workspace_view,
            window_offset_in_tile: layout.window_offset_in_tile
        };
    }

	function setFocusTimestamp(idx, timestamp) {
		windows.setProperty(idx, "focus_secs", timestamp.secs);
		windows.setProperty(idx, "focus_nanos", timestamp.nanos);
	}

	function setWindowLayout(idx, layout) {
		windows.setProperty(idx, "pos_in_scrolling_layout", layout.pos_in_scrolling_layout);
		windows.setProperty(idx, "tile_size", layout.tile_size);
		windows.setProperty(idx, "window_size_factor", layout.window_size);
		windows.setProperty(idx, "tile_pos_in_workspace_view", layout.tile_pos_in_workspace_view);
		windows.setProperty(idx, "window_offset_in_tile", layout.window_offset_in_tile);
	}

    function appendWindow(window) {
        const win_id = window.id;
        windows.append(window);
        _idToIdx[win_id] = windows.count - 1;
    }

    function handleWindowsChanged(event) {
        const new_windows = event.payload.windows;
        windows.clear();
        for (let i = 0; i < new_windows.length; i++) {
            const win = _canonWindowData(new_windows[i]);
            appendWindow(win);
        }
    }

    function handleWindowOpenedOrChanged(event) {
        const window = _canonWindowData(event.payload.window);
        const win_id = window.id;
        const idx = getWindowIndex(win_id);

        if (idx < 0) {
            appendWindow(window);
        } else {
            windows.set(idx, window);
        }
    }

    function handleWindowClosed(event) {
        const win_id = event.payload.id;
        const idx = getWindowIndex(win_id);

        if (idx < 0) {
            console.warn(`(NiriService): Received WindowClosed event for unknown window id ${win_id}`);
            return;
        }
        windows.remove(idx, 1);
		_idToIdx = {};

		// Need to rebuild index map once item is removed
		for (let i = 0; i < windows.count; i++) {
			const winId = windows.get(i).id;
			_idToIdx[winId] = i;
		}
    }

    function handleWindowFocusChanged(event) {
        const id = event.payload.id; // Can be undefined but that does not matter here

        for (let i = 0; i < windows.count; i++) {
            windows.setProperty(i, "is_focused", windows.get(i).id === id);
        }
    }

    function handleFocusTimestampChanged(event) {
        const window_id = event.payload.id;
        const timestamp = event.payload.focus_timestamp;
        const derived_timestamp = _canonFocusTimestampData(timestamp);

        const idx = getWindowIndex(window_id);
        if (idx < 0) {
            console.warn(`(NiriService): Received WindowFocusTimestampChanged event for unknown window id ${window_id}`);
            return;
        }
		setFocusTimestamp(idx, derived_timestamp);
    }

    function handleWindowUrgencyChanged(event) {
        const window_id = event.payload.id;
        const urgency = event.payload.urgent;

        const idx = getWindowIndex(window_id);
        if (idx < 0) {
            console.warn(`(NiriService): Received WindowUrgencyChanged event for unknown window id ${window_id}`);
            return;
        }
        windows.setProperty(idx, "is_urgent", urgency);
    }

    function handleWindowLayoutsChanged(event) {
        const changes = event.payload.changes;

        for (let i = 0; i < changes.length; i++) {
            const window_id = changes[i][0];
            const layout = _canonLayoutData(changes[i][1]);
            const idx = getWindowIndex(window_id);

            if (idx < 0) {
                console.warn(`(NiriService): Received WindowLayoutChanged event for unknown window id ${window_id}`);
                continue;
            }

			setWindowLayout(idx, layout);
        }
    }

    function handleEvent(event) {
        switch (event.kind) {
        case "WindowsChanged":
            root.handleWindowsChanged(event);
            break;
        case "WindowOpenedOrChanged":
            root.handleWindowOpenedOrChanged(event);
            break;
        case "WindowClosed":
            root.handleWindowClosed(event);
            break;
        case "WindowFocusChanged":
            root.handleWindowFocusChanged(event);
            break;
        case "WindowFocusTimestampChanged":
            root.handleFocusTimestampChanged(event);
            break;
        case "WindowUrgencyChanged":
            root.handleWindowUrgencyChanged(event);
            break;
        case "WindowLayoutsChanged":
            root.handleWindowLayoutsChanged(event);
            break;
		default:
			return;
        }
		windowsUpdated();
    }

    Connections {
        target: root.listener
        function onEventEmitted(event) {
            root.handleEvent(event);
        }
    }
}
