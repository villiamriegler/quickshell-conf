import QtQuick
import qs.Services.Compositors.Niri

Rectangle {
	id: root
    required property var modelData

	property int wsid: modelData.id
	property int idx: modelData.idx
	property string name: modelData.name
	property bool is_urgent: modelData.is_urgent
	property bool is_active: modelData.is_active
	property bool is_focused: modelData.is_focused
	property int active_window_id: modelData.active_window_id

	property bool hovered: mouse.containsMouse

    width: is_focused ? 44 : 22
    height: 12
    radius: height / 2
	
	color: hovered ? "#5277C3" : is_focused ? "#7ebae4" : is_active ?  "#5277C3" : "#3c3836"
    opacity: is_focused || hovered ? 1.0 : is_active ? 0.75 : 0.5

	MouseArea {
		id: mouse
		hoverEnabled: true
		anchors.fill: parent
		onClicked: {
			NiriService.activateWorkspace(root.idx.toString());
		}
	}
}
