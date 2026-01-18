import QtQuick
import QtQuick.Layouts
import Quickshell
import Quickshell.Wayland

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

            height: 40
            color: "#1c1822"

            WlrLayershell.layer: WlrLayer.Top
            WlrLayershell.exclusiveZone: height

            Rectangle {
                anchors.fill: parent
                color: "#1c1822"
                border.color: "#3e364e"
                border.width: 1

                RowLayout {
                    anchors.fill: parent
                    anchors.margins: 8
                    spacing: 12

                    // App launcher button
                    Rectangle {
                        width: 32
                        height: 32
                        radius: 6
                        color: launcherMouse.containsMouse ? "#262130" : "transparent"
                        border.color: "#c7a1d8"
                        border.width: 1

                        Text {
                            anchors.centerIn: parent
                            text: "◈"
                            color: "#c7a1d8"
                            font.pixelSize: 20
                        }

                        MouseArea {
                            id: launcherMouse
                            anchors.fill: parent
                            hoverEnabled: true
                            onClicked: {
                                // TODO: Launch app menu
                                console.log("Launcher clicked")
                            }
                        }
                    }

                    // Workspace/task area (placeholder)
                    Rectangle {
                        Layout.fillWidth: true
                        height: 32
                        radius: 6
                        color: "#262130"

                        Text {
                            anchors.centerIn: parent
                            text: "Tasks will appear here"
                            color: "#a79ab0"
                            font.pixelSize: 12
                        }
                    }

                    // System tray area (placeholder)
                    Row {
                        spacing: 8

                        // Clock
                        Rectangle {
                            width: clockText.width + 16
                            height: 32
                            radius: 6
                            color: "#262130"

                            Text {
                                id: clockText
                                anchors.centerIn: parent
                                text: Qt.formatDateTime(new Date(), "HH:mm")
                                color: "#e9e4f0"
                                font.pixelSize: 13
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
                        }

                        // Power button
                        Rectangle {
                            width: 32
                            height: 32
                            radius: 6
                            color: powerMouse.containsMouse ? "#e9899d" : "#262130"
                            border.color: "#e9899d"
                            border.width: 1

                            Text {
                                anchors.centerIn: parent
                                text: "⏻"
                                color: powerMouse.containsMouse ? "#1e1418" : "#e9899d"
                                font.pixelSize: 16
                            }

                            MouseArea {
                                id: powerMouse
                                anchors.fill: parent
                                hoverEnabled: true
                                onClicked: {
                                    // TODO: Show power menu
                                    console.log("Power clicked")
                                }
                            }
                        }
                    }
                }
            }
        }
    }
}
