pragma Singleton

import QtQuick
import Quickshell
import qs.Services.Compositors.Niri.Ipc
import qs.Services.Compositors.Niri.Consumers

Singleton {
    id: root
	property alias workspaces: workspaceConsumer.workspaces

	Component.onCompleted: {
		EventStreamListener.init();
	}

	WorkspaceConsumer {
		id: workspaceConsumer
		listener: EventStreamListener
	}
}
