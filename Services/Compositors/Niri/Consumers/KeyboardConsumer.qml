import QtQuick
import qs.Services.Compositors.Niri.Ipc

Item {
    id: root
    property var listener: EventStreamListener
    property ListModel layouts: ListModel {}
	property int active_index: -1

	function _canonLayout(name) {
		return {name: name, active: false};
	}

	function handleKeyboardLayoutsChanged(event) {
		const keyboard_layouts = event.payload.keyboard_layouts;
		const names = keyboard_layouts.names;
		const current = keyboard_layouts.current_idx;

		layouts.clear();
		for (let i = 0; i < names.length; i++) {
			layouts.append(_canonLayout(names[i]));
		}
		active_index = current;
		layouts.setProperty(active_index, "active", true);
	}

	function handledKeyboardLayoutSwitched(event) {
		const current = event.payload.idx;
		layouts.setProperty(active_index, "active", false);
		active_index = current;
		layouts.setProperty(active_index, "active", true);
	}

    function handleEvent(event) {
		switch (event.kind) {
			case "KeyboardLayoutsChanged":
				root.handleKeyboardLayoutsChanged(event);
				break;
			case "KeyboardLayoutSwitched":
				root.handledKeyboardLayoutSwitched(event);
				break;
		}
    }

    Connections {
        target: root.listener
        function onEventEmitted(event) {
            root.handleEvent(event);
        }
    }
}
