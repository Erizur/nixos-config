import QtQuick
import Quickshell

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
