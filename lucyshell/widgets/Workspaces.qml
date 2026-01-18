import QtQuick
import Quickshell

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
