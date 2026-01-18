import QtQuick
import QtQuick.Layouts
import Quickshell
import Quickshell.Wayland

Rectangle {
    id: root
    width: clockText.width + 12
    height: 24
    radius: 4
    color: "#262130"

    required property var parentWindow

    SystemClock {
        id: clock
        precision: SystemClock.Seconds
    }

    Text {
        id: clockText
        anchors.centerIn: parent
        text: Qt.formatDateTime(clock.date, "hh:mm:ss - yyyy-MM-dd")
        color: "#e9e4f0"
        font.pixelSize: 12
        font.family: "JetBrainsMono Nerd Font"
    }

    MouseArea {
        anchors.fill: parent
        onClicked: calendarPopup.visible = !calendarPopup.visible
    }

    PopupWindow {
        id: calendarPopup
        visible: false

        implicitWidth: 280
        implicitHeight: 320

        screen: parentWindow.screen

        anchor {
            window: parentWindow
            rect.x: parentWindow.width - implicitWidth - 10
            rect.y: -implicitHeight - 8
        }

        color: "transparent"

        Rectangle {
            anchors.fill: parent
            color: "#1c1822"
            radius: 8
            border.color: "#3e364e"
            border.width: 1
            ColumnLayout {
                anchors.fill: parent
                anchors.margins: 12
                spacing: 8
                Text {
                    text: Qt.formatDateTime(new Date(), "MMMM yyyy")
                    color: "#e9e4f0"
                    font.pixelSize: 16
                    font.bold: true
                    Layout.alignment: Qt.AlignHCenter
                }
                Text {
                    text: Qt.formatDateTime(new Date(), "dddd, MMMM d")
                    color: "#a79ab0"
                    font.pixelSize: 13
                    Layout.alignment: Qt.AlignHCenter
                }
                Rectangle {
                    Layout.fillWidth: true
                    height: 1
                    color: "#3e364e"
                }
                Grid {
                    columns: 7
                    rowSpacing: 4
                    columnSpacing: 4
                    Layout.alignment: Qt.AlignHCenter
                    Repeater {
                        model: ["S", "M", "T", "W", "T", "F", "S"]
                        Text {
                            text: modelData
                            color: "#a79ab0"
                            font.pixelSize: 11
                            horizontalAlignment: Text.AlignHCenter
                            width: 32
                        }
                    }
                }
                Item { Layout.fillHeight: true }
            }
        }
        MouseArea {
            anchors.fill: parent
            onPressed: mouse => mouse.accepted = false
        }
    }
}
