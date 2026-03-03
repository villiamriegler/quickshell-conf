import QtQuick
import qs.Services.Compositors.Niri.Ipc

Item {
    id: root
    property var listener: EventStreamListener
    property ListModel workspaces: ListModel {}
    property var _idToIdx: ({})

	signal workspacesUpdated

	function getWorkspaceIndex(workspaceId) {
		const idx = _idToIdx[workspaceId];
		return idx !== undefined ? idx : -1;
	}

    function _canonWorkspaceData(raw) {
        return {
            id: raw.id,
            idx: raw.idx,
            name: raw.name || "",
            output: raw.output || "",
            is_urgent: raw.is_urgent,
            is_active: raw.is_active,
            is_focused: raw.is_focused,
            active_window_id: raw.active_window_id ?? -1
        };
    }

    function _updateWorkspaces(workspacesData) {
        workspaces.clear();
        _idToIdx = {};
        for (let i = 0; i < workspacesData.length; i++) {
            const ws = _canonWorkspaceData(workspacesData[i]);
            const id = ws.id;
            workspaces.append(ws);
            _idToIdx[id] = i;
        }
    }

    function handleWorkspacesChanged(event) {
        const workspaces = event.payload.workspaces;
        root._updateWorkspaces(workspaces);
    }

    function handleWorkspaceUrgencyChanged(event) {
        const workspace_id = event.payload.id;
        const urgency = event.payload.urgent;

        const idx = getWorkspaceIndex(workspace_id);
        if (idx < 0)
            return;

        workspaces.setProperty(idx, "is_urgent", !!urgency);
    }

    function handleWorkspaceActivated(event) {
        const workspace_id = event.payload.id;
        const focused = event.payload.focused;

		const idx = getWorkspaceIndex(workspace_id);
		if (idx < 0)
			return;

		const output = workspaces.get(idx).output;

		// If the current workspace is now focused then it applies globally
		// only a single workspace can be focused at once
		for (let i = 0; i < workspaces.count && focused; i++) {
			workspaces.setProperty(i, "is_focused", false);
		}

		// Only a single workspace can be active on a given output at once 
		// all other workspaces on the same output becomes incative
		for (let i = 0; i < workspaces.count; i++) {
			const ws = workspaces.get(i);

			if (ws.output === output) {
				workspaces.setProperty(i, "is_active", false);
			}
		}

		// Make the current workspace active
		workspaces.setProperty(idx, "is_active", true);
		workspaces.setProperty(idx, "is_focused", focused);
	}

	function handleWorkspaceActiveWindowChanged(event) {
		const workspace_id = event.payload.workspace_id;
		const active_window_id = event.payload.active_window_id;

		const idx = getWorkspaceIndex(workspace_id);
		if (idx < 0)
			return;

		workspaces.setProperty(idx, "active_window_id", active_window_id ?? -1);
	}

	function handleEvent(event) {
		switch (event.kind) {
			case "WorkspacesChanged":
				root.handleWorkspacesChanged(event);
				break;
			case "WorkspaceUrgencyChanged":
				root.handleWorkspaceUrgencyChanged(event);
				break;
			case "WorkspaceActivated":
				root.handleWorkspaceActivated(event);
				break;
			case "WorkspaceActiveWindowChanged":
				root.handleWorkspaceActiveWindowChanged(event);
				break;
			default: 
				return;
		}
		workspacesUpdated()
	}

    Connections {
        target: root.listener
        function onEventEmitted(event) {
			root.handleEvent(event);
        }
    }
}
