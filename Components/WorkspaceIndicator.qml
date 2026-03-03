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

    width: is_focused || is_active ? height * 4 : height
    height: 12
    radius: height / 2
	
	color: is_focused  || is_active ? "#7ebae4" : "#3c3836"
    opacity: is_focused || hovered ? 1.0 :  0.5

	MouseArea {
		id: mouse
		hoverEnabled: true
		anchors.fill: parent
		onClicked: {
			NiriService.activateWorkspace(root.idx.toString());
		}
	}

	Behavior on width {
		NumberAnimation {
			duration: 200
			easing.type: Easing.OutQuad
		}
	}

	Behavior on color {
		ColorAnimation {
			duration: 200
			easing.type: Easing.OutQuad
		}
	}

	Behavior on opacity {
		NumberAnimation {
			duration: 200
			easing.type: Easing.OutQuad
		}
	}
}
