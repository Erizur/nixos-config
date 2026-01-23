import QtQuick
import QtQuick.Controls
import QtQuick.Layouts
import Quickshell
import Quickshell.Wayland
import Quickshell.Services.SystemTray

PanelWindow {
    id: root
    visible: false
    color: "transparent"

    WlrLayershell.layer: WlrLayer.Overlay
    WlrLayershell.keyboardFocus: WlrKeyboardFocus.OnDemand

    property var parentWindow
    property var targetItem
    property var menuHandle

    onVisibleChanged: {
        if (visible) {
            updatePosition()
            stack.replace(null, menuPage, { handle: menuHandle }, StackView.Immediate)
            contentScope.forceActiveFocus()
        }
    }

    anchors {
        left: true
        top: parentWindow ? parentWindow.anchors.top : false
        bottom: parentWindow ? parentWindow.anchors.bottom : false
    }

    margins {
        top: parentWindow ? (parentWindow.anchors.top ? 5 : 0) : 0
        bottom: parentWindow ? (parentWindow.anchors.bottom ? 5 : 0) : 0
    }

    function updatePosition() {
        if (!targetItem || !parentWindow) return
            const pos = targetItem.mapToItem(parentWindow.contentItem, 0, 0)
            margins.left = pos.x - (implicitWidth / 3)
    }

    implicitWidth: 200
    implicitHeight: stack.currentItem ? stack.currentItem.implicitHeight + 10 : 100

    FocusScope {
        id: contentScope
        anchors.fill: parent

        onActiveFocusChanged: {
            if (!activeFocus && root.visible) {
                root.visible = false
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
                onPressed: mouse.accepted = true
            }

            StackView {
                id: stack
                anchors.fill: parent
                initialItem: menuPage

                pushEnter: Transition { NumberAnimation { property: "opacity"; from: 0; to: 1; duration: 100 } }
                pushExit: Transition { NumberAnimation { property: "opacity"; from: 1; to: 0; duration: 100 } }
                popEnter: Transition { NumberAnimation { property: "opacity"; from: 0; to: 1; duration: 100 } }
                popExit: Transition { NumberAnimation { property: "opacity"; from: 1; to: 0; duration: 100 } }
            }
        }
    }

    Component {
        id: menuPage

        ColumnLayout {
            id: pageColumn
            property var handle

            spacing: 2
            width: parent.width

            Rectangle {
                visible: stack.depth > 1
                Layout.fillWidth: true
                Layout.preferredHeight: 28
                color: backMouse.containsMouse ? "#262130" : "transparent"

                RowLayout {
                    anchors.fill: parent
                    anchors.leftMargin: 4
                    Text { text: "◀"; color: "#a79ab0"; font.pixelSize: 10 }
                    Text { text: "Back"; color: "#a79ab0"; font.pixelSize: 11; Layout.fillWidth: true }
                }
                MouseArea {
                    id: backMouse
                    anchors.fill: parent
                    hoverEnabled: true
                    onClicked: stack.pop()
                }
            }

            Rectangle {
                visible: stack.depth > 1
                Layout.fillWidth: true
                Layout.preferredHeight: 1
                color: "#3e364e"
            }

            Loader {
                id: openerLoader
                active: pageColumn.handle !== undefined && pageColumn.handle !== null
                sourceComponent: QsMenuOpener {
                    menu: pageColumn.handle
                }
            }

            Repeater {
                model: (openerLoader.item && openerLoader.item.children) ? openerLoader.item.children : []

                Rectangle {
                    required property var modelData

                    Layout.fillWidth: true
                    Layout.preferredHeight: modelData.isSeparator ? 1 : 24

                    color: modelData.isSeparator
                    ? "#3e364e"
                    : (itemMouse.containsMouse && modelData.enabled ? "#262130" : "transparent")

                    visible: true

                    RowLayout {
                        visible: !modelData.isSeparator
                        anchors.fill: parent
                        anchors.leftMargin: 8
                        anchors.rightMargin: 8

                        Image {
                            source: (modelData.icon && modelData.icon !== "") ? modelData.icon : ""
                            sourceSize.width: 16
                            sourceSize.height: 16
                            visible: source != ""
                            smooth: true
                        }

                        Text {
                            text: modelData.text
                            color: modelData.enabled ? "#e9e4f0" : "#504945"
                            font.pixelSize: 11
                            Layout.fillWidth: true
                            elide: Text.ElideRight
                        }

                        Text {
                            visible: modelData.hasChildren
                            text: "▶"
                            color: "#a79ab0"
                            font.pixelSize: 10
                        }
                    }

                    MouseArea {
                        id: itemMouse
                        anchors.fill: parent
                        hoverEnabled: true
                        enabled: !modelData.isSeparator && modelData.enabled
                        onClicked: {
                            if (modelData.hasChildren) {
                                stack.push(menuPage, { handle: modelData })
                            } else {
                                modelData.triggered()
                                root.visible = false
                            }
                        }
                    }
                }
            }
        }
    }
}
