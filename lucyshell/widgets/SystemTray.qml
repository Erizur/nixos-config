import QtQuick
import QtQuick.Layouts
import Quickshell
import Quickshell.Services.SystemTray

Row {
    id: trayRow
    spacing: 4
    property var parentWindow: null

    TrayMenu {
        id: contextMenu
        parentWindow: trayRow.parentWindow
    }

    Repeater {
        model: SystemTray.items

        Rectangle {
            id: trayItem
            required property var modelData

            width: 24
            height: 24
            radius: 3
            color: trayMouse.containsMouse ? "#262130" : "transparent"

            Image {
                anchors.centerIn: parent

                source: {
                    const iconName = modelData.icon ?? ""
                    if (iconName.startsWith("/") || iconName.startsWith("file://")) {
                        return iconName
                    }

                    if (iconName.includes("?path=")) {
                        const parts = iconName.split("?path=")
                        return parts[1]
                    }

                    return iconName || ""
                }

                smooth: true
                fillMode: Image.PreserveAspectFit

                sourceSize.width: 24
                sourceSize.height: 24

                Text {
                    visible: parent.status !== Image.Ready || parent.source == ""
                    anchors.centerIn: parent
                    text: modelData.title?.substring(0, 1) ?? "?"
                    color: "#e9e4f0"
                    font.pixelSize: 12
                }
            }

            MouseArea {
                id: trayMouse
                anchors.fill: parent
                hoverEnabled: true
                acceptedButtons: Qt.LeftButton | Qt.RightButton | Qt.MiddleButton

                onClicked: mouse => {
                    if (mouse.button === Qt.LeftButton) {
                        modelData.activate()
                    } else if (mouse.button === Qt.RightButton) {
                        if (modelData.menu) {
                            contextMenu.targetItem = trayItem
                            contextMenu.menuHandle = modelData.menu
                            contextMenu.visible = true
                        }
                    } else if (mouse.button === Qt.MiddleButton) {
                        modelData.secondaryActivate()
                    }
                }
            }

            Rectangle {
                visible: trayMouse.containsMouse && (modelData.title || modelData.tooltipTitle)
                anchors.bottom: parent.top
                anchors.bottomMargin: 8
                anchors.horizontalCenter: parent.horizontalCenter

                width: tooltipText.width + 16
                height: tooltipText.height + 10
                radius: 4
                color: "#1c1822"
                border.color: "#3e364e"
                border.width: 1

                z: 999

                Text {
                    id: tooltipText
                    anchors.centerIn: parent
                    text: modelData.tooltipTitle || modelData.title || ""
                    color: "#e9e4f0"
                    font.pixelSize: 11
                }
            }
        }
    }
}
