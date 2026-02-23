import Quickshell // for PanelWindow
import QtQuick // for Text

import qs.Widgets

Scope {
    Variants {
        model: Quickshell.screens

            PanelWindow {
                required property var modelData

                screen: modelData

                anchors {
                    top: true
                    left: true
                    right: true
                }

                implicitHeight: 30

                ClockWidget {
                    anchors.centerIn: parent
                }
            }
    }
}
