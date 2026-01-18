import QtQuick
import QtQuick.Layouts
import Quickshell
import Quickshell.Wayland
import Quickshell.Io

import "widgets" as Widgets

ShellRoot {
    Variants {
        model: Quickshell.screens

        PanelWindow {
            id: mainPanel
            property var modelData
            screen: modelData

            anchors {
                left: true
                right: true
                bottom: true
            }

            implicitHeight: 32
            color: "transparent"

            WlrLayershell.layer: WlrLayer.Top
            WlrLayershell.exclusiveZone: implicitHeight

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
                    Widgets.AppLauncher {}

                    // Workspace indicators
                    Widgets.Workspaces {}

                    Widgets.Tasks {
                        parentWindow: mainPanel
                        Layout.fillWidth: true
                        Layout.alignment: Qt.AlignLeft
                    }

                    Item { Layout.fillWidth: true }

                    // System tray area
                    Row {
                        spacing: 6

                        Widgets.SystemTray {}

                        Rectangle {
                            width: 1
                            height: 20
                            color: "#3e364e"
                        }

                        Widgets.VolumeControl {}
                        Widgets.NetworkIndicator {}
                        Widgets.Clock { parentWindow: mainPanel }
                        Widgets.PowerButton { parentWindow: mainPanel }
                    }
                }
            }
        }
    }
}
