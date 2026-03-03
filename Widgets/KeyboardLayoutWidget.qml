import QtQuick
import qs.Services.Compositors.Niri
import qs.Components

Item {
    id: root

    SortFilterProxyModel {
        id: layoutProxy
        model: NiriService.keyboardLayouts
        filters: [
            ValueFilter {
                roleName: "active"
                value: true
            }
        ]
    }
    implicitWidth: container.implicitWidth
    implicitHeight: parent.height

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
                model: layoutProxy

                delegate: Text {
                    required property var modelData
					property bool hovered: mouse.containsMouse

                    text: "   " + modelData.name
                    color: "#ebdbb2"
					opacity: hovered ? 0.75 : 1.0

					MouseArea {
						id: mouse
						hoverEnabled: true
						anchors.fill: parent
						onClicked: {
							NiriService.cycleKeyboardLayouts();
						}
					}
                }
            }
        }
    }
}
