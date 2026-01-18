import QtQuick
import Quickshell
import Quickshell.Wayland

Row {
    id: root
    spacing: 4

    property var parentWindow: null

    Repeater {
        model: ToplevelManager.toplevels

        Rectangle {
            id: taskItem
            required property var modelData

            readonly property bool isOnScreen: root.parentWindow ? modelData.screens.includes(root.parentWindow.screen) : true

            visible: isOnScreen
            width: visible ? 24 : 0
            height: 24

            radius: 3
            color: modelData.activated ? "#262130" : "transparent"
            border.color: modelData.activated ? "#c7a1d8" : "transparent"
            border.width: 1

            Image {
                anchors.centerIn: parent
                width: 18
                height: 18
                source: Quickshell.iconPath(modelData.appId, true) || "application-x-executable"
                fillMode: Image.PreserveAspectFit
                smooth: true
            }

            MouseArea {
                id: mouseArea
                anchors.fill: parent
                hoverEnabled: true
                acceptedButtons: Qt.LeftButton | Qt.RightButton

                onClicked: (mouse) => {
                    if (mouse.button === Qt.LeftButton) {
                        if (modelData.activated) {
                            modelData.minimized = true
                        } else {
                            modelData.activate()
                        }
                    } else if (mouse.button === Qt.RightButton) {
                        modelData.close()
                    }
                }
            }

            Rectangle {
                visible: mouseArea.containsMouse
                anchors.bottom: parent.top
                anchors.bottomMargin: 8
                anchors.horizontalCenter: parent.horizontalCenter
                z: 999

                width: titleText.width + 12
                height: titleText.height + 8
                radius: 4
                color: "#1c1822"
                border.color: "#3e364e"
                border.width: 1

                Text {
                    id: titleText
                    anchors.centerIn: parent
                    text: modelData.title
                    color: "#e9e4f0"
                    font.pixelSize: 11
                }
            }
        }
    }
}
