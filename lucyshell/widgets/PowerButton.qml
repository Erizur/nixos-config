import QtQuick
import QtQuick.Layouts
import Quickshell
import Quickshell.Wayland

Rectangle {
    id: root
    width: 24
    height: 24
    radius: 4
    color: powerMouse.containsMouse ? "#e9899d" : "transparent"
    border.color: powerMouse.containsMouse ? "#e9899d" : "transparent"
    border.width: 1

    required property var parentWindow

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

    PopupWindow {
        id: powerMenu
        visible: false
        implicitWidth: 180
        implicitHeight: 160
        screen: parentWindow.screen

        anchor {
            window: parentWindow
            rect.x: parentWindow.width - implicitWidth - 10
            rect.y: -implicitHeight - 8
        }

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
}
