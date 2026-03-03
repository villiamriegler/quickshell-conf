import QtQuick

Rectangle {
    id: container

    property int padx: 10

    anchors.left: parent.left
    anchors.top: parent.top
    anchors.bottom: parent.bottom

    color: "#282828"

    implicitHeight: childrenRect.height
    implicitWidth: childrenRect.width + 2 * padx
    height: implicitHeight
    width: implicitWidth

    radius: height / 2
}
