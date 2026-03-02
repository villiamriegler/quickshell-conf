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

			WorkspaceWidget {
				outputName: panel.outputName
				anchors.left: parent.left
				anchors.top: parent.top
				anchors.bottom: parent.bottom
				anchors.leftMargin: 5
				anchors.topMargin: 5
			}
        }
    }
}
