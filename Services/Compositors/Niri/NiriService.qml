pragma Singleton

import QtQuick
import Quickshell
import qs.Services.Compositors.Niri.Ipc
import qs.Services.Compositors.Niri.Consumers

Singleton {
    id: root
	property alias workspaces: workspaceConsumer.workspaces
	property alias windows: windowConsumer.windows
	property alias keyboardLayouts: keyboardConsumer.layouts

	Component.onCompleted: {
		EventStreamListener.init();
	}

	WorkspaceConsumer {
		id: workspaceConsumer
		listener: EventStreamListener
	}

	WindowConsumer {
		id: windowConsumer
		listener: EventStreamListener
	}

	KeyboardConsumer {
		id: keyboardConsumer
		listener: EventStreamListener
	}

	function activateWorkspace(workspaceIdx) {
		Quickshell.execDetached(["niri", "msg", "action", "focus-workspace", workspaceIdx]);
	}

	function cycleKeyboardLayouts() {
		Quickshell.execDetached(["niri", "msg", "action", "switch-layout", "next"]);
	}
}
