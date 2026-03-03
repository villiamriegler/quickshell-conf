import QtQuick
import qs.Components

Item {
    id: root
    required property var workspaceModel

	implicitWidth: container.implicitWidth
	implicitHeight: parent.height

    BarWidgetContainer {
		id: container

        Row {
            id: row
            spacing: 5
            anchors.verticalCenter: parent.verticalCenter
			anchors.horizontalCenter: parent.horizontalCenter

            Repeater {
                id: repeater
                model: root.workspaceModel

                delegate: WorkspaceIndicator {}
            }
        }
    }
}
