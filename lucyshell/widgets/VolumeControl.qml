import QtQuick
import Quickshell
import Quickshell.Services.Pipewire
import "../services" // Ensure this path is correct to find Audio.qml

Rectangle {
    id: root
    width: volumeRow.width + 12
    height: 24
    radius: 4
    color: (volumeMouse.containsMouse || audioMenu.visible) ? "#3c3836" : "#262130"

    required property var parentWindow

    readonly property real volume: Audio.value
    readonly property bool isMuted: Audio.sink?.audio?.muted ?? false

    Row {
        id: volumeRow
        anchors.centerIn: parent
        spacing: 4

        Text {
            text: isMuted ? "🔇" : "🔊"
            font.pixelSize: 12
            anchors.verticalCenter: parent.verticalCenter
        }

        Text {
            id: volumeText
            text: isMuted ? "" : Math.round(volume * 100) + "%"
            color: "#e9e4f0"
            font.pixelSize: 11
            anchors.verticalCenter: parent.verticalCenter
        }
    }

    MouseArea {
        id: volumeMouse
        anchors.fill: parent
        hoverEnabled: true
        acceptedButtons: Qt.LeftButton | Qt.MiddleButton | Qt.RightButton

        onClicked: (mouse) => {
            if (mouse.button === Qt.LeftButton) {
                // Open the Menu
                audioMenu.visible = !audioMenu.visible
            } else if (mouse.button === Qt.MiddleButton || mouse.button === Qt.RightButton) {
                // Quick Mute
                Audio.toggleMute()
            }
        }

        onWheel: wheel => {
            if (wheel.angleDelta.y > 0) {
                Audio.incrementVolume()
            } else {
                Audio.decrementVolume()
            }
        }
    }

    // Include the new AudioMenu
    AudioMenu {
        id: audioMenu
        parentWindow: root.parentWindow
        targetItem: root
    }
}
