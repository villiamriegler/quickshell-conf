import QtQuick
import qs.Services

Rectangle {
    id: root
	property int padx: 10
    color: "#282828"
    implicitWidth: text.implicitWidth + 2 * padx
    implicitHeight: text.implicitHeight
	radius: height / 2

    Text {
        id: text
		anchors.centerIn: parent
		color: "#ebdbb2"
        text: Time.time
    }
}
