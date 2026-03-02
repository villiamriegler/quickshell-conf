import QtQuick
import qs.Services.Compositors.Niri
import qs.Components

Item {
    id: root
    required property string outputName

    SortFilterProxyModel {
        id: workspaceProxy
        model: NiriService.workspaces
        sorters: [
            RoleSorter {
                roleName: "idx"
                sortOrder: Qt.AscendingOrder
            }
        ]
        filters: [
            ValueFilter {
                roleName: "output"
                value: root.outputName
            }
        ]
    }

    Rectangle {
        id: container
		property int padx: 10
		anchors.left: parent.left
		anchors.top: parent.top
		anchors.bottom: parent.bottom

        color: "#282828"

        implicitHeight: row.implicitHeight
        implicitWidth: row.implicitWidth + 2 * padx
        height: implicitHeight
        width: implicitWidth

		radius: height / 2

        Row {
            id: row
            spacing: 5
            anchors.verticalCenter: parent.verticalCenter
			anchors.horizontalCenter: parent.horizontalCenter

            Repeater {
                id: repeater
                model: workspaceProxy

                delegate: WorkspaceIndicator {}
            }
        }
    }
}
