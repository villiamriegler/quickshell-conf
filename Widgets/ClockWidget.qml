import QtQuick
import qs.Services
import qs.Components

Item {
    id: root

    implicitWidth: container.implicitWidth
    implicitHeight: parent.height

    BarWidgetContainer {
		id: container
        Text {
            id: text
            anchors.centerIn: parent
            color: "#ebdbb2"
            text: Time.time
        }
    }
}
