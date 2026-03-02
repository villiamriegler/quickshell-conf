import QtQuick
import qs.Services.Compositors.Niri

Item {
	id: root
	required property string outputName

	SortFilterProxyModel {
		id: model
		model: NiriService.workspaces
		sorters: [
			RoleSorter {
				roleName: "idx"
				sortOrder: Qt.AscendingOrder
			}
		]
		filters: [
			ValueFilter {
				roleName: "output"
				value: root.outputName
			}
		]
	}

	Row {
		id: row
		spacing: 10
		anchors.verticalCenter: parent.verticalCenter

		Repeater {
			model: model

			delegate: Rectangle {
				width: 20
				height: 20

				opacity: model.is_active ? 1 : 0.5
				color: model.is_focused ? "blue" : (model.is_urgent ? "red" : "gray")

				Text {
					anchors.centerIn: parent
					text: String(model.idx)
					color: "white"
					font.pixelSize: 12
				}
			}
		}
	}
}
