import QtQuick
import QtQuick.Layouts
import Quickshell
import Quickshell.Wayland

Rectangle {
    id: root
    width: clockText.width + 12
    height: 24
    radius: 4
    color: clockMouse.containsMouse || calendarPopup.visible ? "#3c3836" : "#262130"

    required property var parentWindow

    SystemClock {
        id: clock
        precision: SystemClock.Seconds
    }

    Calendar {
        id: calendarPopup
        parentWindow: root.parentWindow
    }

    Text {
        id: clockText
        anchors.centerIn: parent
        text: Qt.formatDateTime(clock.date, "hh:mm:ss\nyyyy-MM-dd")
        horizontalAlignment: Text.AlignHCenter
        lineHeight: 0.8
        color: "#e9e4f0"
        font.pixelSize: 12
        font.family: "Noto Sans"
    }

    MouseArea {
        id: clockMouse
        anchors.fill: parent
        hoverEnabled: true
        onClicked: {
            calendarPopup.visible = !calendarPopup.visible
            if (calendarPopup.visible) {
                calendarPopup.refreshCalendar()
                calendarPopup.updatePosition()
                calendarPopup.popupScope.forceActiveFocus()
            }
        }
    }
}
