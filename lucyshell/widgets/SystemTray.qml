import QtQuick
import QtQuick.Layouts
import Quickshell
import Quickshell.Services.SystemTray

Row {
    spacing: 4

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
                width: 18
                height: 18
                source: modelData.icon?.url ?? ""
                smooth: true
                fillMode: Image.PreserveAspectFit

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
                        console.log("Context menus are not yet implemented in this shell.")

                        /* if (modelData.menu) {
                         *                           modelData.menu.open(mouse.x, mouse.y)
                    }
                    */
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
