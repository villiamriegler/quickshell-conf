pragma ComponentBehavior: Bound
import Quickshell // for PanelWindow
import QtQuick    // for Text, ListModel, Connections

Scope {
    id: root
    property bool anchorTop: false
    property bool anchorLeft: false
    property bool anchorRight: false
    property bool anchorBottom: false
    property int panelHeight: 30
    property string color: "transparent"

    default property Component contentData

    Variants {
        model: Quickshell.screens
        PanelWindow {
            id: panel
            required property var modelData

            screen: modelData
            color: root.color

            implicitHeight: root.panelHeight

            anchors {
                top: root.anchorTop
                left: root.anchorLeft
                right: root.anchorRight
                bottom: root.anchorBottom
            }

            Loader {
                anchors.fill: parent
                sourceComponent: root.contentData

                readonly property var screen: panel.modelData
            }
        }
    }
}
