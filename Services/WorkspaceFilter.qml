import QtQuick
import qs.Services.Compositors.Niri

Item {
	id: root
	required property string screenName
	property var workspaceModel: NiriService.workspaces

	property alias model: workspaceProxy

    SortFilterProxyModel {
        id: workspaceProxy
        model: root.workspaceModel
        sorters: [
            RoleSorter {
                roleName: "idx"
                sortOrder: Qt.AscendingOrder
            }
        ]
        filters: [
            ValueFilter {
                roleName: "output"
                value: root.screenName
            }
        ]
    }

}
