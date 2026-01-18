import QtQuick
import Quickshell
import "../services"

Rectangle {
    width: networkRow.width + 12
    height: 24
    radius: 4
    color: netMouse.containsMouse ? "#262130" : "transparent"

    Row {
        id: networkRow
        anchors.centerIn: parent
        spacing: 4

        Text {
            color: "#e9e4f0"

            text: {
                const map = {
                    "lan": "󰈀",
                    "signal_wifi_4_bar": "󰤨", "network_wifi": "󰤨",
                    "network_wifi_3_bar": "󰤥",
                    "network_wifi_2_bar": "󰤢",
                    "network_wifi_1_bar": "󰤟",
                    "signal_wifi_0_bar": "󰤯",
                    "signal_wifi_statusbar_not_connected": "󰤫",
                    "wifi_find": "󱚽",
                    "signal_wifi_off": "󰤮",
                    "signal_wifi_bad": "󰤫"
                }
                return map[Network.materialSymbol] || "󰤮"
            }
            font.pixelSize: 14
            anchors.verticalCenter: parent.verticalCenter
        }

        Text {
            id: networkText
            text: Network.ethernet ? "Ethernet" : (Network.wifiStatus === "connected" ? Network.networkName : "Disconnected")
            color: "#e9e4f0"
            font.pixelSize: 11
            anchors.verticalCenter: parent.verticalCenter
        }
    }

    MouseArea {
        id: netMouse
        anchors.fill: parent
        hoverEnabled: true
        acceptedButtons: Qt.LeftButton | Qt.RightButton

        onClicked: (mouse) => {
            if (mouse.button === Qt.LeftButton) Network.toggleWifi()
                if (mouse.button === Qt.RightButton) Quickshell.execDetached(["nm-connection-editor"])
        }
    }
}
