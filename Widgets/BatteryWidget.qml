import QtQuick
import Quickshell.Services.UPower
import Quickshell.Widgets

import qs.Components

Item {
    id: root

    implicitWidth: container.implicitWidth
    implicitHeight: parent.height

    visible: UPower.displayDevice.isLaptopBattery

    property int percent: Math.round(UPower.displayDevice.percentage * 100)
    property var state: UPower.displayDevice.state

    property bool charging: state == UPowerDeviceState.Charging

    property var icons: ["󰂃", "󰁺", "󰁻", "󰁼", "󰁽", "󰁾", "󰁿", "󰂀", "󰂁", "󰂂", "󰁹"]
    property int level: Math.min(Math.floor(percent / 10), 10)

    BarWidgetContainer {
        id: container

        width: implicitWidth
        height: implicitHeight

        Item {
            anchors.centerIn: parent
            width: label.implicitWidth

            Row {
                id: label
                spacing: 5
                anchors.centerIn: parent

                Text {
                    id: batteryIcon
                    anchors.verticalCenter: parent.verticalCenter
                    text: root.charging ? "󰂄" : root.icons[root.level]
                    color: "#ebdbb2"
                }

                Text {
                    id: percentage
                    anchors.verticalCenter: parent.verticalCenter
                    text: root.percent + "%"
                    color: "#ebdbb2"
                }
            }
        }
    }
}
