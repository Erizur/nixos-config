import QtCore
import QtQuick
import QtQuick.Controls
import QtQuick.Effects
import QtQuick.Layouts
import QtQuick.Window

import Quickshell
import Quickshell.Io
import Quickshell.Wayland
import Quickshell.Services.Greetd
import Quickshell.Services.Pam

Variants {
    model: Quickshell.screens

    PanelWindow {
        id: root

        property var modelData
        screen: modelData
        anchors {
            left: true
            right: true
            top: true
            bottom: true
        }
        exclusionMode: ExclusionMode.Normal
        WlrLayershell.layer: WlrLayer.Overlay
        WlrLayershell.keyboardFocus: WlrKeyboardFocus.Exclusive
        color: "#282828"
        
        property string screenName: root.screen?.name ?? ""
        property bool isPrimaryScreen: {
            if (!Qt.application.screens || Qt.application.screens.length === 0)
                return true
            if (!screenName || screenName === "")
                return true
            return screenName === Qt.application.screens[0].name
        }

        // Session management
        QtObject {
            id: sessionManager
            property int currentIndex: 0
            property var sessions: [
                { name: "KDE Plasma", exec: "startplasma-wayland" },
                { name: "Wayfire", exec: "wayfire" },
            ]
            
            property string currentSessionName: sessions[currentIndex].name
            property string currentSessionExec: sessions[currentIndex].exec
            
            function nextSession() {
                currentIndex = (currentIndex + 1) % sessions.length
            }
            
            function previousSession() {
                currentIndex = (currentIndex - 1 + sessions.length) % sessions.length
            }
        }

        // Center all content
        ColumnLayout {
            anchors.centerIn: parent
            spacing: 20

            Text {
                id: messageText
                text: "Welcome to NixOS"
                color: "#ebdbb2"
                font.pixelSize: 24
                Layout.alignment: Qt.AlignHCenter
            }

            // Session selector
            Rectangle {
                Layout.alignment: Qt.AlignHCenter
                width: 300
                height: 50
                radius: 8
                color: "#3c3836"
                border.color: "#ebdbb2"
                border.width: 1

                RowLayout {
                    anchors.fill: parent
                    anchors.margins: 8
                    spacing: 8

                    // Previous button
                    Rectangle {
                        width: 34
                        height: 34
                        radius: 4
                        color: prevMouse.containsMouse ? "#504945" : "transparent"
                        
                        Text {
                            anchors.centerIn: parent
                            text: "◀"
                            color: "#ebdbb2"
                            font.pixelSize: 16
                        }
                        
                        MouseArea {
                            id: prevMouse
                            anchors.fill: parent
                            hoverEnabled: true
                            onClicked: sessionManager.previousSession()
                        }
                    }

                    // Session name
                    Text {
                        Layout.fillWidth: true
                        text: sessionManager.currentSessionName
                        color: "#ebdbb2"
                        font.pixelSize: 16
                        horizontalAlignment: Text.AlignHCenter
                        verticalAlignment: Text.AlignVCenter
                    }

                    // Next button
                    Rectangle {
                        width: 34
                        height: 34
                        radius: 4
                        color: nextMouse.containsMouse ? "#504945" : "transparent"
                        
                        Text {
                            anchors.centerIn: parent
                            text: "▶"
                            color: "#ebdbb2"
                            font.pixelSize: 16
                        }
                        
                        MouseArea {
                            id: nextMouse
                            anchors.fill: parent
                            hoverEnabled: true
                            onClicked: sessionManager.nextSession()
                        }
                    }
                }
            }

            TextField {
                id: userInput
                placeholderText: "Username"
                color: "#ebdbb2"
                background: Rectangle { 
                    color: "#3c3836"
                    radius: 4
                }
                Layout.preferredWidth: 300
                Layout.alignment: Qt.AlignHCenter

                onTextChanged: {
                    if (userInput.text === "")
                        passInput.enabled = false
                    else
                        passInput.enabled = true    
                }

                onAccepted: {
                    if (passInput.enabled && passInput.text !== "") {
                        startSession()
                    } else {
                        passInput.forceActiveFocus()
                    }
                }
            }

            TextField {
                id: passInput
                placeholderText: "Password"
                echoMode: TextInput.Password
                visible: true
                enabled: false
                color: "#ebdbb2"
                background: Rectangle { 
                    color: "#3c3836"
                    radius: 4
                }
                Layout.preferredWidth: 300
                Layout.alignment: Qt.AlignHCenter

                onAccepted: {
                    startSession()
                }
            }

            Button {
                text: "Login"
                Layout.alignment: Qt.AlignHCenter
                Layout.preferredWidth: 300
                enabled: userInput.text !== "" && passInput.text !== ""
                
                background: Rectangle {
                    color: parent.enabled ? (parent.hovered ? "#689d6a" : "#458588") : "#504945"
                    radius: 4
                }
                
                contentItem: Text {
                    text: parent.text
                    color: "#ebdbb2"
                    horizontalAlignment: Text.AlignHCenter
                    verticalAlignment: Text.AlignVCenter
                }
                
                onClicked: startSession()
            }
        }

        function startSession() {
            messageText.text = "Starting " + sessionManager.currentSessionName + "..."
            userInput.visible = false
            passInput.visible = false
            Greetd.createSession(userInput.text)
        }

        // --- Greetd Logic ---
        Connections {
            target: Greetd
            enabled: isPrimaryScreen

            function onAuthMessage(message, error, responseRequired, echoResponse) {
                messageText.text = message
                
                if (responseRequired) {
                    Greetd.respond(passInput.text)
                } else if (!error) {
                    Greetd.respond("")
                }
            }

            function onAuthFailure(message) {
                messageText.text = "Login failed: " + message
                passInput.visible = true
                userInput.visible = true
                userInput.text = ""
                passInput.text = ""
                userInput.forceActiveFocus()
            }

            function onReadyToLaunch() {
                messageText.text = "Success! Launching session..."
                Greetd.launch([sessionManager.currentSessionExec])
            }
        }

        Component.onCompleted: {
            userInput.forceActiveFocus()
        }
    }
}