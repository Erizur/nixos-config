import QtQuick
import QtQuick.Window
import Quickshell
import Quickshell.Io

Grid {
    id: root
    spacing: 1

    rows: layoutRows
    flow: Grid.LeftToRight

    required property var parentWindow

    property int itemHeight: 24
    property int itemWidth: Math.round(itemHeight * (Screen.width / Screen.height))

    property int sessionType: {
        const desktop = Quickshell.env("XDG_CURRENT_DESKTOP") || ""
        if (desktop.includes("KDE")) return 1
            if (desktop.toLowerCase().includes("wayfire")) return 2
                return 0
    }

    property int activeIndex: 0
    property int workspaceCount: 4
    property int layoutRows: 1

    Timer {
        interval: 300
        running: true
        repeat: true
        triggeredOnStart: true
        onTriggered: {
            if (sessionType === 1) kdePoller.running = true
                if (sessionType === 2) wayfirePoller.running = true
        }
    }

    Process {
        id: kdePoller
        command: ["sh", "-c", "echo $(qdbus org.kde.KWin /KWin org.kde.KWin.currentDesktop) $(qdbus org.kde.KWin /VirtualDesktopManager org.kde.KWin.VirtualDesktopManager.count) $(qdbus org.kde.KWin /VirtualDesktopManager org.kde.KWin.VirtualDesktopManager.rows 2>/dev/null || echo 1)"]
        stdout: SplitParser {
            onRead: data => {
                const parts = data.trim().split(" ")

                if (parts.length >= 3) {
                    const current = parseInt(parts[0])
                    const count = parseInt(parts[1])
                    const rows = parseInt(parts[2])

                    if (!isNaN(current)) root.activeIndex = current - 1
                        if (!isNaN(count)) root.workspaceCount = count
                            if (!isNaN(rows)) root.layoutRows = Math.max(1, rows)
                    resizeItems()
                }
            }
        }
    }

    Process {
        id: wayfirePoller
        command: ["wf-msg", "get_focused_workspace"]
        stdout: SplitParser {
            onRead: data => {
                try {
                    const json = JSON.parse(data)
                    const index = (json.y * json.grid_width) + json.x

                    root.activeIndex = index
                    root.workspaceCount = json.grid_width * json.grid_height
                    root.layoutRows = Math.max(1, json.grid_height)
                } catch (e) {}
            }
        }
    }

    function resizeItems() {
        itemHeight = (parentWindow.implicitHeight / root.layoutRows) - 2
        itemWidth = Math.round(itemHeight * (Screen.width / Screen.height))
    }

    function switchWorkspace(index) {
        if (sessionType === 1) {
            const cmd = "qdbus org.kde.KWin /KWin org.kde.KWin.setCurrentDesktop " + (index + 1)
            Quickshell.execDetached(["sh", "-c", cmd])
            root.activeIndex = index
        }
        else if (sessionType === 2) {
            const cols = Math.ceil(root.workspaceCount / root.layoutRows)
            const x = index % cols
            const y = Math.floor(index / cols)

            const cmd = "wf-msg set_workspace " + x + " " + y
            Quickshell.execDetached(["sh", "-c", cmd])
            root.activeIndex = index
        }
    }

    Repeater {
        model: root.workspaceCount

        Rectangle {
            width: root.itemWidth
            height: root.itemHeight
            radius: 3

            readonly property bool isActive: index === root.activeIndex
            readonly property bool isHovered: hoverHandler.hovered

            color: isHovered ? "#3c3836" : "transparent"
            border.color: isActive ? "#c7a1d8" : (isHovered ? "#504945" : "transparent")
            border.width: 1

            Text {
                anchors.centerIn: parent
                text: index + 1
                color: "#a79ab0"
                font.pixelSize: 11
                font.bold: parent.isActive
            }

            HoverHandler {
                id: hoverHandler
            }

            MouseArea {
                anchors.fill: parent
                onClicked: root.switchWorkspace(index)
            }
        }
    }
}
