import QtQuick
import qs.Services.Compositors.Niri
import qs.Components

Item {
    id: root

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
                model: NiriService.keyboardLayouts

                Item {
                    id: delagate
                    required property var modelData
                    property bool active: modelData.active
                    property string name: modelData.name
                    property bool hovered: mouse.containsMouse

                    opacity: !active ? 0.0 : hovered ? 0.75 : 1.0
                    visible: opacity > 0.0
                    clip: true

                    width: active ? label.implicitWidth : 0.0
                    height: label.implicitHeight

                  Text {
                        id: label
                        text: "   " + parent.name
                        color: "#ebdbb2"
                    }

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
