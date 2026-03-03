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

    signal workspacesUpdated
    signal windowsUpdated

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

    Connections {
        target: windowConsumer
        function onWindowsUpdated() {
            root.windowsUpdated();
        }
    }

    Connections {
        target: workspaceConsumer
        function onWorkspacesUpdated() {
            root.workspacesUpdated();
        }
    }

    function activateWorkspace(workspaceIdx) {
        Quickshell.execDetached(["niri", "msg", "action", "focus-workspace", workspaceIdx]);
    }

    function cycleKeyboardLayouts() {
        Quickshell.execDetached(["niri", "msg", "action", "switch-layout", "next"]);
    }
}
