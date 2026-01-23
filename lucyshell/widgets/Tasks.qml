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

            readonly property bool isActive: modelData.activated
            readonly property bool isHovered: mouseArea.containsMouse

            visible: isOnScreen
            height: root.parentWindow.implicitHeight - 4
            width: visible ? height + 4 : 0

            radius: 4
            color: isActive ? "#262130" : (isHovered ? "#3c3836" : "#1d202180")

            border.color: isActive ? "#c7a1d8" : (isHovered ? "#504945" : "transparent")
            border.width: 1

            Image {
                anchors.centerIn: parent
                source: getAppIcon(modelData.appId, "image-missing")
                fillMode: Image.PreserveAspectFit
                smooth: true
                sourceSize.width: taskItem.width - 4
                sourceSize.height: taskItem.height - 4
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

    function getAppIcon(name: string, fallback: string): string {
        const icon = DesktopEntries.heuristicLookup(name)?.icon;
        if (fallback !== "undefined")
            return Quickshell.iconPath(icon, fallback);
        return Quickshell.iconPath(icon);
    }
}
