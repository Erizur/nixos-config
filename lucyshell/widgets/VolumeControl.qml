import QtQuick
import Quickshell
import Quickshell.Services.Pipewire
import "../services" // Ensure this path is correct to find Audio.qml

Rectangle {
    width: volumeRow.width + 12
    height: 24
    radius: 4
    color: volumeMouse.containsMouse ? "#262130" : "transparent"

    readonly property real volume: Audio.value
    readonly property bool isMuted: Audio.sink?.audio?.muted ?? false

    Row {
        id: volumeRow
        anchors.centerIn: parent
        spacing: 4

        Text {
            text: "🔊"
            font.pixelSize: 12
            anchors.verticalCenter: parent.verticalCenter
        }

        Text {
            id: volumeText
            // Change 2: Bind text to the Audio service properties
            text: isMuted ? "Muted" : Math.round(volume * 100) + "%"
            color: "#e9e4f0"
            font.pixelSize: 11
            anchors.verticalCenter: parent.verticalCenter
        }
    }

    MouseArea {
        id: volumeMouse
        anchors.fill: parent
        hoverEnabled: true

        // Change 3: Use the toggleMute function from Audio.qml
        onClicked: {
            Audio.toggleMute()
        }

        // Change 4: Use the increment/decrement functions from Audio.qml
        onWheel: wheel => {
            if (wheel.angleDelta.y > 0) {
                Audio.incrementVolume()
            } else {
                Audio.decrementVolume()
            }
        }
    }
}
