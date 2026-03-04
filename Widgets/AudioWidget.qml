import QtQuick
import QtQuick.Layouts
import QtQuick.Controls

import Quickshell
import Quickshell.Widgets
import Quickshell.Services.Pipewire

import qs.Components

Item {
    id: root

    implicitWidth: container.implicitWidth
    implicitHeight: parent.height

    PwObjectTracker {
        objects: [Pipewire.defaultAudioSink]
    }

    property var sink: Pipewire.defaultAudioSink

    readonly property real volume: Math.round(sink.audio.volume * 100)
    readonly property bool muted: sink.audio.muted

    BarWidgetContainer {
        id: container

        width: implicitWidth
        height: implicitHeight

        Item {
            anchors.centerIn: parent
            width: label.implicitWidth

            Row {
                id: label
                spacing: 5
                anchors.centerIn: parent

                Text {
                    id: volumeIcon
                    anchors.verticalCenter: parent.verticalCenter
                    text: ""
                    color: "#ebdbb2"

                    states: [
                        State {
                            name: "muted"
                            when: root.muted || root.volume === 0
                            PropertyChanges {
                                target: volumeIcon
                                text: " "
                            }
                        },
                        State {
                            name: "low"
                            when: root.volume > 0 && root.volume <= 33
                            PropertyChanges {
                                target: volumeIcon
                                text: ""
                            }
                        },
                        State {
                            name: "medium"
                            when: root.volume > 33 && root.volume <= 66
                            PropertyChanges {
                                target: volumeIcon
                                text: ""
                            }
                        },
                        State {
                            name: "high"
                            when: root.volume > 66
                            PropertyChanges {
                                target: volumeIcon
                                text: " "
                            }
                        }
                    ]
                }

                Text {
                    id: text
                    anchors.verticalCenter: parent.verticalCenter
					visible: !root.muted && root.volume > 0
                    text: root.volume + "%"
                    color: "#ebdbb2"
                }
            }
        }
    }
}
