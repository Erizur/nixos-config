import QtQuick
import QtQuick.Layouts
import Quickshell
import Quickshell.Services.Mpris
import Quickshell.Wayland

Rectangle {
    id: root

    property var currentPlayer: {
        const players = Mpris.players.values
        const playing = players.find(p => p.playbackStatus === Mpris.PlaybackStatus.Playing)
        return playing || players[0] || null
    }

    visible: currentPlayer !== null
    width: mediaRow.width + 24
    height: 24

    color: (mediaMouse.containsMouse || mediaPopup.visible) ? "#3c3836" : "#262130"

    required property var parentWindow

    Row {
        id: mediaRow
        anchors.centerIn: parent
        spacing: 8

        Text {
            text: "🎵"
            font.pixelSize: 12
            anchors.verticalCenter: parent.verticalCenter
        }

        Text {
            id: label
            text: root.currentPlayer ?
            (root.currentPlayer.metadata["xesam:title"] || "Unknown Title") + " - " +
            (root.currentPlayer.metadata["xesam:artist"] || "Unknown Artist")
            : ""

            color: "#e9e4f0"
            font.pixelSize: 11
            font.family: "JetBrainsMono Nerd Font"

            width: Math.min(implicitWidth, 200)
            elide: Text.ElideRight
            anchors.verticalCenter: parent.verticalCenter
        }
    }

    MouseArea {
        id: mediaMouse
        anchors.fill: parent
        hoverEnabled: true

        onClicked: {
            mediaPopup.visible = !mediaPopup.visible
            if (mediaPopup.visible) {
                mediaPopup.updatePosition()
                popupScope.forceActiveFocus()
            }
        }

        onWheel: (wheel) => {
            if (!root.currentPlayer) return
                if (wheel.angleDelta.y > 0) root.currentPlayer.volume += 0.05
                    else root.currentPlayer.volume -= 0.05
        }
    }

    PanelWindow {
        id: mediaPopup
        visible: false

        WlrLayershell.layer: WlrLayer.Overlay
        WlrLayershell.keyboardFocus: WlrKeyboardFocus.OnDemand

        property int popupX: 0

        function updatePosition() {
            if (!parentWindow) return
                const pos = root.mapToItem(parentWindow.contentItem, 0, 0)
                mediaPopup.popupX = pos.x - (mediaPopup.implicitWidth - root.width) / 2

                if (mediaPopup.popupX < 5) mediaPopup.popupX = 5
                    if (root.screen && (mediaPopup.popupX + mediaPopup.implicitWidth > root.screen.width)) {
                        mediaPopup.popupX = root.screen.width - mediaPopup.implicitWidth - 5
                    }
        }

        anchors {
            left: true
            top: parentWindow ? parentWindow.anchors.top : false
            bottom: parentWindow ? parentWindow.anchors.bottom : false
        }

        margins {
            left: popupX
            top: (parentWindow && parentWindow.anchors.top) ? 5 : 0
            bottom: (parentWindow && parentWindow.anchors.bottom) ? 5 : 0
        }

        implicitWidth: 300
        implicitHeight: contentCol.implicitHeight + 24

        screen: parentWindow ? parentWindow.screen : null

        FocusScope {
            id: popupScope
            anchors.fill: parent

            onActiveFocusChanged: {
                if (!activeFocus && mediaPopup.visible) mediaPopup.visible = false
            }

            Rectangle {
                anchors.fill: parent
                color: "#1c1822"
                border.color: "#3e364e"
                border.width: 1
                clip: true

                MouseArea { anchors.fill: parent; onPressed: mouse.accepted = true }

                ColumnLayout {
                    id: contentCol
                    anchors.fill: parent
                    anchors.margins: 12
                    spacing: 12

                    Rectangle {
                        Layout.alignment: Qt.AlignHCenter
                        width: 120; height: 120
                        radius: 8
                        color: "#262130"
                        clip: true

                        Image {
                            anchors.fill: parent
                            fillMode: Image.PreserveAspectCrop
                            source: root.currentPlayer?.metadata["mpris:artUrl"] || ""
                            visible: status === Image.Ready
                        }

                        Text {
                            anchors.centerIn: parent
                            text: "🎵"
                            font.pixelSize: 48
                            visible: parent.children[0].status !== Image.Ready
                        }
                    }

                    ColumnLayout {
                        Layout.fillWidth: true
                        spacing: 2

                        Text {
                            Layout.fillWidth: true
                            horizontalAlignment: Text.AlignHCenter
                            text: root.currentPlayer?.metadata["xesam:title"] || "No Title"
                            color: "#e9e4f0"
                            font.pixelSize: 14
                            font.bold: true
                            elide: Text.ElideRight
                        }

                        Text {
                            Layout.fillWidth: true
                            horizontalAlignment: Text.AlignHCenter
                            text: root.currentPlayer?.metadata["xesam:artist"] || "Unknown Artist"
                            color: "#c7a1d8"
                            font.pixelSize: 12
                            elide: Text.ElideRight
                        }
                    }

                    Item {
                        Layout.fillWidth: true
                        Layout.preferredHeight: 4

                        property real progress: {
                            if (!root.currentPlayer || root.currentPlayer.length <= 0) return 0
                                return root.currentPlayer.position / root.currentPlayer.length
                        }

                        Rectangle {
                            width: parent.width; height: parent.height
                            radius: 2
                            color: "#3e364e"
                        }

                        Rectangle {
                            width: parent.width * parent.progress
                            height: parent.height
                            radius: 2
                            color: "#c7a1d8"
                        }
                    }

                    RowLayout {
                        Layout.alignment: Qt.AlignHCenter
                        spacing: 24

                        Text {
                            text: "⏮"
                            color: "#e9e4f0"
                            font.pixelSize: 20
                            MouseArea {
                                anchors.fill: parent
                                cursorShape: Qt.PointingHandCursor
                                onClicked: root.currentPlayer?.previous()
                            }
                        }

                        Rectangle {
                            width: 40; height: 40
                            radius: 20
                            color: "#c7a1d8"

                            Text {
                                anchors.centerIn: parent
                                text: (root.currentPlayer?.playbackStatus === Mpris.PlaybackStatus.Playing) ? "⏸" : "▶"
                                color: "#1c1822"
                                font.pixelSize: 18
                            }

                            MouseArea {
                                anchors.fill: parent
                                cursorShape: Qt.PointingHandCursor
                                onClicked: root.currentPlayer?.playPause()
                            }
                        }

                        Text {
                            text: "⏭"
                            color: "#e9e4f0"
                            font.pixelSize: 20
                            MouseArea {
                                anchors.fill: parent
                                cursorShape: Qt.PointingHandCursor
                                onClicked: root.currentPlayer?.next()
                            }
                        }
                    }
                }
            }
        }
    }
}
