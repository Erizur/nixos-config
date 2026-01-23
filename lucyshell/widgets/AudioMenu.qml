import QtQuick
import QtQuick.Layouts
import QtQuick.Controls
import Quickshell
import Quickshell.Wayland
import "../services" // Points to Audio.qml

PanelWindow {
    id: root
    visible: false
    color: "transparent"

    WlrLayershell.layer: WlrLayer.Overlay
    WlrLayershell.keyboardFocus: WlrKeyboardFocus.OnDemand

    property var parentWindow
    property var targetItem
    property int popupX: 0

    onVisibleChanged: {
        if (visible) {
            updatePosition()
            contentScope.forceActiveFocus()
        }
    }

    function updatePosition() {
        if (!targetItem || !parentWindow) return
            const pos = targetItem.mapToItem(parentWindow.contentItem, 0, 0)
            root.popupX = pos.x - (root.implicitWidth - targetItem.width) / 2

            if (root.popupX < 5) root.popupX = 5
                if (root.screen && (root.popupX + root.implicitWidth > root.screen.width)) {
                    root.popupX = root.screen.width - root.implicitWidth - 5
                }
    }

    anchors {
        left: true
        top: parentWindow ? parentWindow.anchors.top : true
        bottom: parentWindow ? parentWindow.anchors.bottom : false
    }

    margins {
        left: popupX
        top: (parentWindow && parentWindow.anchors.top) ? 5 : 0
        bottom: (parentWindow && parentWindow.anchors.bottom) ? 5 : 0
    }

    implicitWidth: 300
    implicitHeight: contentCol.implicitHeight + 20

    screen: parentWindow ? parentWindow.screen : null

    FocusScope {
        id: contentScope
        anchors.fill: parent

        onActiveFocusChanged: {
            if (!activeFocus && root.visible) {
                root.visible = false
            }
        }

        Rectangle {
            anchors.fill: parent
            color: "#1c1822"
            border.color: "#3e364e"
            border.width: 1
            clip: true

            MouseArea {
                anchors.fill: parent
                onPressed: mouse.accepted = true
            }

            ColumnLayout {
                id: contentCol
                anchors.fill: parent
                anchors.margins: 8
                spacing: 4

                RowLayout {
                    Layout.fillWidth: true
                    spacing: 4

                    Rectangle {
                        width: 32; height: 32; radius: 4
                        color: muteMouse.containsMouse ? "#3c3836" : "transparent"

                        Text {
                            anchors.centerIn: parent
                            text: Audio.sink?.audio?.muted ? "🔇" : "🔊"
                            font.pixelSize: 16
                        }
                        MouseArea {
                            id: muteMouse
                            anchors.fill: parent
                            hoverEnabled: true
                            onClicked: Audio.toggleMute()
                        }
                    }

                    Item {
                        Layout.fillWidth: true
                        height: 32

                        Rectangle {
                            id: track
                            anchors.centerIn: parent
                            width: parent.width
                            height: 6
                            radius: 3
                            color: "#3e364e"

                            Rectangle {
                                width: parent.width * Math.min(Math.max(Audio.value, 0), 1)
                                height: parent.height
                                radius: 3
                                color: Audio.sink?.audio?.muted ? "#928374" : "#b16286"
                            }
                        }

                        MouseArea {
                            anchors.fill: parent
                            cursorShape: Qt.PointingHandCursor

                            function updateVolume(mouse) {
                                let val = mouse.x / width
                                val = Math.max(0, Math.min(1, val))
                                if (Audio.sink && Audio.sink.audio) {
                                    Audio.sink.audio.volume = val
                                }
                            }

                            onPressed: (mouse) => updateVolume(mouse)
                            onPositionChanged: (mouse) => updateVolume(mouse)
                            onWheel: (wheel) => {
                                if (wheel.angleDelta.y > 0) Audio.incrementVolume()
                                    else Audio.decrementVolume()
                            }
                        }
                    }

                    Text {
                        text: Math.round(Audio.value * 100) + "%"
                        color: "#a79ab0"
                        font.pixelSize: 12
                        Layout.preferredWidth: 35
                        horizontalAlignment: Text.AlignRight
                    }
                }

                Rectangle {
                    Layout.fillWidth: true; height: 1
                    color: "#3e364e"
                }

                Text {
                    text: "Output Devices"
                    color: "#a79ab0"
                    font.pixelSize: 11
                    font.bold: true
                }

                ColumnLayout {
                    Layout.fillWidth: true
                    spacing: 4

                    Repeater {
                        model: Audio.outputDevices

                        Rectangle {
                            required property var modelData
                            Layout.fillWidth: true
                            Layout.preferredHeight: 28
                            radius: 4
                            color: (Audio.sink === modelData) ? "#262130" : "transparent"
                            border.color: (Audio.sink === modelData) ? "#b16286" : "transparent"
                            border.width: 1

                            RowLayout {
                                anchors.fill: parent
                                anchors.leftMargin: 8
                                anchors.rightMargin: 8
                                spacing: 8

                                Text {
                                    text: (Audio.sink === modelData) ? "✓" : ""
                                    color: "#b16286"
                                    font.pixelSize: 12
                                    Layout.preferredWidth: 12
                                }

                                Text {
                                    text: Audio.friendlyDeviceName(modelData)
                                    color: "#e9e4f0"
                                    font.pixelSize: 12
                                    elide: Text.ElideRight
                                    Layout.fillWidth: true
                                }
                            }

                            MouseArea {
                                anchors.fill: parent
                                cursorShape: Qt.PointingHandCursor
                                onClicked: Audio.setDefaultSink(modelData)
                            }
                        }
                    }
                }

                Rectangle {
                    Layout.fillWidth: true; height: 1
                    color: "#3e364e"
                    visible: Audio.inputDevices.length > 0
                }

                Text {
                    text: "Input Devices"
                    color: "#a79ab0"
                    font.pixelSize: 11
                    font.bold: true
                    visible: Audio.inputDevices.length > 0
                }

                ColumnLayout {
                    Layout.fillWidth: true
                    spacing: 4
                    visible: Audio.inputDevices.length > 0

                    Repeater {
                        model: Audio.inputDevices

                        Rectangle {
                            required property var modelData
                            Layout.fillWidth: true
                            Layout.preferredHeight: 28
                            radius: 4
                            color: (Audio.source === modelData) ? "#262130" : "transparent"
                            border.color: (Audio.source === modelData) ? "#b16286" : "transparent"
                            border.width: 1

                            RowLayout {
                                anchors.fill: parent
                                anchors.leftMargin: 8
                                anchors.rightMargin: 8
                                spacing: 8

                                Text {
                                    text: (Audio.source === modelData) ? "✓" : ""
                                    color: "#b16286"
                                    font.pixelSize: 12
                                    Layout.preferredWidth: 12
                                }

                                Text {
                                    text: Audio.friendlyDeviceName(modelData)
                                    color: "#e9e4f0"
                                    font.pixelSize: 12
                                    elide: Text.ElideRight
                                    Layout.fillWidth: true
                                }
                            }

                            MouseArea {
                                anchors.fill: parent
                                cursorShape: Qt.PointingHandCursor
                                onClicked: Audio.setDefaultSource(modelData)
                            }
                        }
                    }
                }
            }
        }
    }
}
