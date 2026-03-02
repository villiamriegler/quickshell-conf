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

            anchors {
                top: true
                left: true
                right: true
            }

            implicitHeight: 30

            // Clock (center)
            ClockWidget {
                anchors.centerIn: parent
            }

			WorkspaceWidget {
				outputName: panel.outputName
				anchors.left: parent.left
				anchors.verticalCenter: parent.verticalCenter
				anchors.leftMargin: 10
			}
        }
    }
}
