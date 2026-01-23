import QtQuick
import QtQuick.Layouts
import Quickshell
import Quickshell.Wayland

PanelWindow {
    id: root
    visible: false
    color: "transparent"

    WlrLayershell.layer: WlrLayer.Overlay
    WlrLayershell.keyboardFocus: WlrKeyboardFocus.OnDemand

    required property var parentWindow
    property int popupX: 0

    property var dayModel: []
    property var weekHeaders: []
    property string titleMonthYear: ""
    property string subTitleFullDate: ""

    property int currentYear: 0
    property int currentMonth: 0
    property int today: 0

    function refreshCalendar() {
        const now = new Date()
        const locale = Qt.locale() // Get system locale

        currentYear = now.getFullYear()
        currentMonth = now.getMonth()
        today = now.getDate()

        let t1 = now.toLocaleDateString(locale)
        titleMonthYear = t1.charAt(0).toUpperCase() + t1.slice(1)

        let t2 = now.toLocaleDateString(locale, "MMMM")
        subTitleFullDate = t2.charAt(0).toUpperCase() + t2.slice(1)

        let headers = []
        const firstDayOfWeek = locale.firstDayOfWeek

        for (let i = 0; i < 7; i++) {
            let dayIdx = (firstDayOfWeek + i) % 7
            let name = locale.dayName(dayIdx, 1)
            headers.push(name.charAt(0).toUpperCase())
        }
        weekHeaders = headers

        const firstDateOfMonth = new Date(currentYear, currentMonth, 1)
        const dayOfWeek = firstDateOfMonth.getDay()
        const daysInMonth = new Date(currentYear, currentMonth + 1, 0).getDate()

        let padding = (dayOfWeek - firstDayOfWeek + 7) % 7

        let arr = []
        for (let i = 0; i < padding; i++) arr.push("")
            for (let d = 1; d <= daysInMonth; d++) arr.push(d)
                dayModel = arr
    }

    function updatePosition() {
        if (!parentWindow) return
            const pos = root.mapToItem(parentWindow.contentItem, 0, 0)
            calendarPopup.popupX = pos.x - (calendarPopup.implicitWidth - root.width) / 2

            if (calendarPopup.popupX < 5) calendarPopup.popupX = 5
    }

    anchors {
        right: true
        top: parentWindow ? parentWindow.anchors.top : false
        bottom: parentWindow ? parentWindow.anchors.bottom : false
    }

    margins {
        top: (parentWindow && parentWindow.anchors.top) ? 5 : 0
        bottom: (parentWindow && parentWindow.anchors.bottom) ? 5 : 0
    }

    implicitWidth: 280
    implicitHeight: contentCol.implicitHeight + 24

    screen: parentWindow ? parentWindow.screen : null

    FocusScope {
        id: popupScope
        anchors.fill: parent

        onActiveFocusChanged: {
            if (!activeFocus && calendarPopup.visible) {
                calendarPopup.visible = false
            }
        }

        Rectangle {
            anchors.fill: parent
            color: "#1c1822"
            border.color: "#3e364e"
            border.width: 1
            clip: true

            MouseArea {
                anchors.fill: parent
                onPressed: (mouse) => mouse.accepted = true
            }

            ColumnLayout {
                id: contentCol
                anchors.fill: parent
                anchors.margins: 12
                spacing: 8

                Text {
                    text: titleMonthYear
                    color: "#e9e4f0"
                    font.pixelSize: 16
                    font.bold: true
                    Layout.alignment: Qt.AlignHCenter
                }

                Rectangle {
                    Layout.fillWidth: true
                    Layout.preferredHeight: 1
                    color: "#3e364e"
                    Layout.topMargin: 2
                    Layout.bottomMargin: 2
                }

                Text {
                    text: subTitleFullDate
                    color: "#a79ab0"
                    font.pixelSize: 13
                    Layout.alignment: Qt.AlignHCenter
                }

                GridLayout {
                    columns: 7
                    columnSpacing: 4
                    rowSpacing: 4
                    Layout.alignment: Qt.AlignHCenter

                    Repeater {
                        model: calendarPopup.weekHeaders
                        Text {
                            text: modelData
                            color: "#806d8a"
                            font.pixelSize: 11
                            font.bold: true
                            horizontalAlignment: Text.AlignHCenter
                            Layout.preferredWidth: 32
                        }
                    }

                    Repeater {
                        model: calendarPopup.dayModel
                        Rectangle {
                            Layout.preferredWidth: 32
                            Layout.preferredHeight: 32
                            radius: 16

                            property bool isToday: (modelData === calendarPopup.today)
                            color: isToday ? "#b16286" : "transparent"

                            Text {
                                anchors.centerIn: parent
                                text: modelData
                                color: parent.isToday ? "#1c1822" : (modelData === "" ? "transparent" : "#e9e4f0")
                                font.pixelSize: 12
                                font.bold: parent.isToday
                            }
                        }
                    }
                }
            }
        }
    }

    Component.onCompleted: refreshCalendar()
}
