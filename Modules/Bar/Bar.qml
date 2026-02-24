import Quickshell // for PanelWindow
import QtQuick    // for Text, ListModel, Connections

import qs.Widgets
import qs.Services.Compositors.Niri

Scope {
    id: root

    NiriService {
        id: niri
        Component.onCompleted: init()
        // Optional: dump full model whenever it updates
        // onWorkspacesUpdated: dumpModel(workspaces, "ALL workspaces")
    }

    Variants {
        model: Quickshell.screens

        PanelWindow {
            required property var modelData
            screen: modelData

            // This is the key: QuickshellScreenInfo has name="HDMI-A-5" etc.
            property string outputName: modelData.name

            // Derived per-output model
            ListModel { id: wsForThisOutput }

            function rebuildWs() {
                wsForThisOutput.clear()

                // Guard: niri.workspaces is a ListModel
                for (let i = 0; i < niri.workspaces.count; i++) {
                    const ws = niri.workspaces.get(i)
                    if (ws.output === outputName) {
                        wsForThisOutput.append(ws)
                    }
                }

                // Optional debug
                // console.log("Rebuilt ws for", outputName, "count", wsForThisOutput.count)
            }

            Component.onCompleted: rebuildWs()

            Connections {
                target: niri
                function onWorkspacesUpdated() {
                    rebuildWs()
                }
            }

            anchors {
                top: true
                left: true
                right: true
            }

            implicitHeight: 30

            // --- Example UI: left workspaces, center clock ---
            Item {
                anchors.fill: parent

                // Workspaces (left)
                Row {
                    anchors.left: parent.left
                    anchors.leftMargin: 8
                    anchors.verticalCenter: parent.verticalCenter
                    spacing: 6

                    Repeater {
                        model: wsForThisOutput
                        delegate: Rectangle {
                            required property var modelData
                            property var ws: modelData

                            width: 22
                            height: 22
                            radius: 7
                            color: ws.is_focused ? "#89b4fa" : "#2a2f3a"
                            opacity: ws.is_active ? 1.0 : 0.55

                            Text {
                                anchors.centerIn: parent
                                text: (ws.idx).toString()
                                color: ws.focused ? "#0b0f14" : "#cdd6f4"
                                font.pixelSize: 11
                            }

                            MouseArea {
                                anchors.fill: parent
                                onClicked: niri.focusWorkspace(ws.id ?? ws.idx)
                            }
                        }
                    }
                }

                // Clock (center)
                ClockWidget {
                    anchors.centerIn: parent
                }
            }
        }
    }
}
