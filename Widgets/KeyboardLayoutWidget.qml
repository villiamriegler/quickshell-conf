pragma ComponentBehavior: Bound

import QtQuick
import Quickshell
import Quickshell.Widgets
import qs.Services.Compositors.Niri
import qs.Components

Item {
    id: root

    implicitWidth: container.implicitWidth
    implicitHeight: parent.height

    visible: NiriService.keyboardLayouts.count > 1

    property string layoutName: ""
    property bool hovered: mouse.containsMouse
    property bool showTemporarily: false
    property bool faded: false

    property bool expanded: hovered || showTemporarily

    function fade() {
        faded = true;
        tempFadeTimer.restart();
    }

    Timer {
        id: tempFadeTimer
        repeat: false
        interval: 150
        onTriggered: {
            root.faded = false;
        }
    }

    onLayoutNameChanged: {
        showTemporarily = true;
        tempShowTimer.restart();
    }

    Timer {
        id: tempShowTimer
        repeat: false
        interval: 1000
        onTriggered: {
            root.showTemporarily = false;
        }
    }

    Instantiator {
        model: NiriService.keyboardLayouts

        delegate: QtObject {
            required property var modelData
            property bool active: modelData.active
            property string name: modelData.name

            function maybeSet() {
                if (active) {
                    root.layoutName = String(name);
                }
            }

            onActiveChanged: maybeSet()
            Component.onCompleted: maybeSet()
        }
    }

    MouseArea {
        id: mouse
        anchors.fill: parent
        hoverEnabled: true
        onClicked: {
            NiriService.cycleKeyboardLayouts();
            root.fade();
        }
    }

    BarWidgetContainer {
        id: container

        width: implicitWidth
        height: implicitHeight

        Item {
            id: delagate

            anchors.centerIn: parent
            width: label.implicitWidth
            height: implicitHeight

            Row {
                id: label
                spacing: 5
                anchors.verticalCenter: parent.verticalCenter

                Text {
                    anchors.verticalCenter: parent.verticalCenter
                    text: ""
                    color: "#ebdbb2"
                }

                Item {
                    width: root.expanded ? nameNode.implicitWidth : 0.0
                    height: nameNode.implicitHeight

                    anchors.verticalCenter: parent.verticalCenter
                    clip: true

                    visible: width > 0

                    Text {
                        id: nameNode
                        text: root.layoutName
                        color: "#ebdbb2"

                        opacity: root.expanded ? (root.faded ? 0.50 : 1.0) : 0.0

                        Behavior on opacity {
                            NumberAnimation {
                                duration: 200
                                easing.type: Easing.InOutQuad
                            }
                        }
                    }

                    Behavior on width {
                        NumberAnimation {
                            duration: 200
                            easing.type: Easing.InOutQuad
                        }
                    }
                }
            }
        }
    }
}
