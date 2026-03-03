import Quickshell // for PanelWindow
import QtQuick    // for Text, ListModel, Connections

import qs.Widgets
import qs.Services.Compositors.Niri

Scope {
    id: root

    Variants {
        model: Quickshell.screens

        PanelWindow {
            id: panel
            required property var modelData
            screen: modelData

            // This is the key: QuickshellScreenInfo has name="HDMI-A-5" etc.
            property string outputName: modelData.name
            color: "transparent"

            anchors {
                top: true
                left: true
                right: true
            }

            implicitHeight: 30

            ClockWidget {
                anchors.right: parent.right
                anchors.top: parent.top
                anchors.bottom: parent.bottom
                anchors.rightMargin: 10
                anchors.leftMargin: 5
                anchors.topMargin: 5
            }

            Row {
                spacing: 10
				anchors.leftMargin: 5
				anchors.topMargin: 5

                anchors {
                    top: parent.top
                    bottom: parent.bottom
                    left: parent.left
                    right: parent.right
                }

                height: implicitHeight
                width: implicitWidth

                WorkspaceWidget {
                    id: workspaces
                    outputName: panel.outputName
                }

                KeyboardLayoutWidget {
                    anchors.top: parent.top
                    anchors.bottom: parent.bottom
                }
            }
        }
    }
}
