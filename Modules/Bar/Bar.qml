import Quickshell // for PanelWindow
import QtQuick    // for Text, ListModel, Connections

import qs.Widgets
import qs.Components
import qs.Services.Compositors.Niri
import qs.Services

ScreenPanel {
    anchorTop: true
    anchorLeft: true
    anchorRight: true

    Item {
        id: content
        readonly property var screen: parent.screen

        // Service for filtering workspaces by output and
        // index ordering
        WorkspaceFilter {
            id: workspaceFilter
            screenName: content.screen.name
        }

        Row {
            spacing: 5

            anchors {
                top: parent.top
                bottom: parent.bottom
                right: parent.right
                rightMargin: 5
                topMargin: 5
            }

            height: implicitHeight
            width: implicitWidth

            ClockWidget {}

			BatteryWidget {}

            AudioWidget {}

            KeyboardLayoutWidget {}
        }

        Row {
            spacing: 5

            anchors {
                top: parent.top
                bottom: parent.bottom
                left: parent.left
                leftMargin: 5
                topMargin: 5
            }

            height: implicitHeight
            width: implicitWidth

            WorkspaceWidget {
                id: workspaces
                workspaceModel: workspaceFilter.model
            }
        }
    }
}
