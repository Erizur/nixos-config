import QtQuick
import QtQuick.Layouts
import Quickshell
import Quickshell.Wayland
import Quickshell.Io

ShellRoot {
    Variants {
        model: Quickshell.screens

        PanelWindow {
            property var modelData
            screen: modelData

            anchors {
                left: true
                right: true
                bottom: true
            }

            height: 32
            color: "transparent"

            WlrLayershell.layer: WlrLayer.Top
            WlrLayershell.exclusiveZone: height

            Rectangle {
                anchors.fill: parent
                color: "#1c1822"
                opacity: 0.95

                Rectangle {
                    anchors.top: parent.top
                    width: parent.width
                    height: 1
                    color: "#3e364e"
                }

                RowLayout {
                    anchors.fill: parent
                    anchors.leftMargin: 6
                    anchors.rightMargin: 6
                    spacing: 8

                    // App launcher
                    Rectangle {
                        width: 28
                        height: 28
                        radius: 4
                        color: launcherMouse.containsMouse ? "#262130" : "transparent"

                        Text {
                            anchors.centerIn: parent
                            text: "◈"
                            color: "#c7a1d8"
                            font.pixelSize: 16
                        }

                        MouseArea {
                            id: launcherMouse
                            anchors.fill: parent
                            hoverEnabled: true
                            onClicked: {
                                Quickshell.execDetached(["wofi", "--show", "drun"])
                            }
                        }
                    }

                    // Workspace indicators (1-4)
                    Row {
                        spacing: 4

                        Repeater {
                            model: 4

                            Rectangle {
                                width: 24
                                height: 24
                                radius: 3
                                color: index === 0 ? "#c7a1d8" : "transparent"
                                border.color: "#c7a1d8"
                                border.width: 1

                                Text {
                                    anchors.centerIn: parent
                                    text: index + 1
                                    color: index === 0 ? "#1a151f" : "#c7a1d8"
                                    font.pixelSize: 11
                                    font.bold: index === 0
                                }

                                MouseArea {
                                    anchors.fill: parent
                                    onClicked: {
                                        // Wayfire workspace switching
                                        Quickshell.execDetached(["wtype", "-M", "super", "-P", (index + 1).toString(), "-m", "super"])
                                    }
                                }
                            }
                        }
                    }

                    Item { Layout.fillWidth: true }

                    // System tray area
                    Row {
                        spacing: 6

                        // Volume indicator
                        Rectangle {
                            width: volumeRow.width + 12
                            height: 24
                            radius: 4
                            color: volumeMouse.containsMouse ? "#262130" : "transparent"

                            Row {
                                id: volumeRow
                                anchors.centerIn: parent
                                spacing: 4

                                Text {
                                    text: "🔊"
                                    font.pixelSize: 12
                                    anchors.verticalCenter: parent.verticalCenter
                                }

                                Text {
                                    id: volumeText
                                    text: "50%"
                                    color: "#e9e4f0"
                                    font.pixelSize: 11
                                    anchors.verticalCenter: parent.verticalCenter
                                }
                            }

                            MouseArea {
                                id: volumeMouse
                                anchors.fill: parent
                                hoverEnabled: true
                                onClicked: {
                                    Quickshell.execDetached(["pavucontrol"])
                                }
                                onWheel: wheel => {
                                    if (wheel.angleDelta.y > 0) {
                                        Quickshell.execDetached(["wpctl", "set-volume", "@DEFAULT_AUDIO_SINK@", "5%+"])
                                    } else {
                                        Quickshell.execDetached(["wpctl", "set-volume", "@DEFAULT_AUDIO_SINK@", "5%-"])
                                    }
                                    volumeUpdateTimer.restart()
                                }
                            }
                        }

                        // Network indicator
                        Rectangle {
                            width: 60
                            height: 24
                            radius: 4
                            color: netMouse.containsMouse ? "#262130" : "transparent"

                            Row {
                                anchors.centerIn: parent
                                spacing: 4

                                Text {
                                    text: "📡"
                                    font.pixelSize: 12
                                    anchors.verticalCenter: parent.verticalCenter
                                }

                                Text {
                                    id: networkText
                                    text: "WiFi"
                                    color: "#e9e4f0"
                                    font.pixelSize: 11
                                    anchors.verticalCenter: parent.verticalCenter
                                }
                            }

                            MouseArea {
                                id: netMouse
                                anchors.fill: parent
                                hoverEnabled: true
                                onClicked: {
                                    Quickshell.execDetached(["nm-connection-editor"])
                                }
                            }
                        }

                        // Clock
                        Rectangle {
                            width: clockText.width + 12
                            height: 24
                            radius: 4
                            color: "#262130"

                            Text {
                                id: clockText
                                anchors.centerIn: parent
                                text: Qt.formatDateTime(new Date(), "HH:mm")
                                color: "#e9e4f0"
                                font.pixelSize: 12
                                font.family: "JetBrainsMono Nerd Font"
                            }

                            Timer {
                                interval: 1000
                                running: true
                                repeat: true
                                onTriggered: {
                                    clockText.text = Qt.formatDateTime(new Date(), "HH:mm")
                                }
                            }

                            MouseArea {
                                anchors.fill: parent
                                onClicked: {
                                    // Toggle calendar
                                    calendarPopup.visible = !calendarPopup.visible
                                }
                            }
                        }

                        // Power menu
                        Rectangle {
                            width: 24
                            height: 24
                            radius: 4
                            color: powerMouse.containsMouse ? "#e9899d" : "transparent"
                            border.color: powerMouse.containsMouse ? "#e9899d" : "transparent"
                            border.width: 1

                            Text {
                                anchors.centerIn: parent
                                text: "⏻"
                                color: powerMouse.containsMouse ? "#e9899d" : "#a79ab0"
                                font.pixelSize: 14
                            }

                            MouseArea {
                                id: powerMouse
                                anchors.fill: parent
                                hoverEnabled: true
                                onClicked: {
                                    powerMenu.visible = !powerMenu.visible
                                }
                            }
                        }
                    }
                }
            }

            // Calendar popup
            FloatingWindow {
                id: calendarPopup
                visible: false
                width: 280
                height: 320
                screen: modelData

                x: parent.width - width - 10
                y: parent.height - height - 40

                color: "transparent"

                Rectangle {
                    anchors.fill: parent
                    color: "#1c1822"
                    radius: 8
                    border.color: "#3e364e"
                    border.width: 1

                    ColumnLayout {
                        anchors.fill: parent
                        anchors.margins: 12
                        spacing: 8

                        Text {
                            text: Qt.formatDateTime(new Date(), "MMMM yyyy")
                            color: "#e9e4f0"
                            font.pixelSize: 16
                            font.bold: true
                            Layout.alignment: Qt.AlignHCenter
                        }

                        Text {
                            text: Qt.formatDateTime(new Date(), "dddd, MMMM d")
                            color: "#a79ab0"
                            font.pixelSize: 13
                            Layout.alignment: Qt.AlignHCenter
                        }

                        Rectangle {
                            Layout.fillWidth: true
                            height: 1
                            color: "#3e364e"
                        }

                        Grid {
                            columns: 7
                            rowSpacing: 4
                            columnSpacing: 4
                            Layout.alignment: Qt.AlignHCenter

                            Repeater {
                                model: ["S", "M", "T", "W", "T", "F", "S"]
                                Text {
                                    text: modelData
                                    color: "#a79ab0"
                                    font.pixelSize: 11
                                    horizontalAlignment: Text.AlignHCenter
                                    width: 32
                                }
                            }
                        }

                        Item { Layout.fillHeight: true }
                    }
                }

                MouseArea {
                    anchors.fill: parent
                    onPressed: mouse => mouse.accepted = false
                }
            }

            // Power menu popup
            FloatingWindow {
                id: powerMenu
                visible: false
                width: 180
                height: 160
                screen: modelData

                x: parent.width - width - 10
                y: parent.height - height - 40

                color: "transparent"

                Rectangle {
                    anchors.fill: parent
                    color: "#1c1822"
                    radius: 8
                    border.color: "#3e364e"
                    border.width: 1

                    ColumnLayout {
                        anchors.fill: parent
                        anchors.margins: 8
                        spacing: 4

                        Rectangle {
                            Layout.fillWidth: true
                            height: 32
                            radius: 4
                            color: shutdownMouse.containsMouse ? "#e9899d" : "transparent"

                            Row {
                                anchors.centerIn: parent
                                spacing: 8

                                Text {
                                    text: "⏻"
                                    color: "#e9899d"
                                    font.pixelSize: 16
                                }
                                Text {
                                    text: "Shutdown"
                                    color: "#e9e4f0"
                                    font.pixelSize: 13
                                }
                            }

                            MouseArea {
                                id: shutdownMouse
                                anchors.fill: parent
                                hoverEnabled: true
                                onClicked: {
                                    Quickshell.execDetached(["systemctl", "poweroff"])
                                }
                            }
                        }

                        Rectangle {
                            Layout.fillWidth: true
                            height: 32
                            radius: 4
                            color: rebootMouse.containsMouse ? "#c7a1d8" : "transparent"

                            Row {
                                anchors.centerIn: parent
                                spacing: 8

                                Text {
                                    text: "↻"
                                    color: "#c7a1d8"
                                    font.pixelSize: 16
                                }
                                Text {
                                    text: "Reboot"
                                    color: "#e9e4f0"
                                    font.pixelSize: 13
                                }
                            }

                            MouseArea {
                                id: rebootMouse
                                anchors.fill: parent
                                hoverEnabled: true
                                onClicked: {
                                    Quickshell.execDetached(["systemctl", "reboot"])
                                }
                            }
                        }

                        Rectangle {
                            Layout.fillWidth: true
                            height: 32
                            radius: 4
                            color: suspendMouse.containsMouse ? "#a984c4" : "transparent"

                            Row {
                                anchors.centerIn: parent
                                spacing: 8

                                Text {
                                    text: "💤"
                                    color: "#a984c4"
                                    font.pixelSize: 14
                                }
                                Text {
                                    text: "Suspend"
                                    color: "#e9e4f0"
                                    font.pixelSize: 13
                                }
                            }

                            MouseArea {
                                id: suspendMouse
                                anchors.fill: parent
                                hoverEnabled: true
                                onClicked: {
                                    Quickshell.execDetached(["systemctl", "suspend"])
                                }
                            }
                        }

                        Rectangle {
                            Layout.fillWidth: true
                            height: 32
                            radius: 4
                            color: logoutMouse.containsMouse ? "#e0b7c9" : "transparent"

                            Row {
                                anchors.centerIn: parent
                                spacing: 8

                                Text {
                                    text: "←"
                                    color: "#e0b7c9"
                                    font.pixelSize: 16
                                }
                                Text {
                                    text: "Logout"
                                    color: "#e9e4f0"
                                    font.pixelSize: 13
                                }
                            }

                            MouseArea {
                                id: logoutMouse
                                anchors.fill: parent
                                hoverEnabled: true
                                onClicked: {
                                    Quickshell.execDetached(["wayland-logout"])
                                }
                            }
                        }
                    }
                }
            }

            // Volume update timer
            Timer {
                id: volumeUpdateTimer
                interval: 100
                onTriggered: updateVolume()
            }

            // Update volume on startup
            Component.onCompleted: {
                updateVolume()
            }

            function updateVolume() {
                // Get volume using wpctl
                var process = Quickshell.exec(["wpctl", "get-volume", "@DEFAULT_AUDIO_SINK@"])
                if (process.exitCode === 0) {
                    var output = process.stdout.trim()
                    var match = output.match(/[\d.]+/)
                    if (match) {
                        var vol = Math.round(parseFloat(match[0]) * 100)
                        volumeText.text = vol + "%"
                    }
                }
            }
        }
    }
}
