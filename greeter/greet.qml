import QtCore
import QtQuick
import QtQuick.Controls
import QtQuick.Effects
import QtQuick.Layouts
import Quickshell
import Quickshell.Io
import Quickshell.Services.Greetd
import Quickshell.Services.Pam

ApplicationWindow {
    id: root
    visible: true
    width: 1280
    height: 720
    color: "#282828" // A dark background

    property bool isPrimaryScreen: {
        if (!Qt.application.screens || Qt.application.screens.length === 0)
            return true
        if (!screenName || screenName === "")
            return true
        return screenName === Qt.application.screens[0].name
    }

    // Center all content
    ColumnLayout {
        anchors.centerIn: parent
        spacing: 10

        Text {
            id: messageText
            text: "Welcome to NixOS (Qt 6)"
            color: "#ebdbb2" // A light text color
            font.pixelSize: 24
            Layout.alignment: Qt.AlignHCenter
        }

        TextField {
            id: userInput
            placeholderText: "Username"
            color: "#ebdbb2"
            background: Rectangle { color: "#3c3836" }
            Layout.fillWidth: true

            onTextChanged: {
                if (userInput.text === "")
                    passInput.enabled = false
            }

            // When user hits Enter, start the session
            onAccepted: {
                messageText.text = "Starting session for " + userInput.text
                userInput.visible = false
                passInput.visible = false
                Greetd.createSession(userInput.text)
            }
        }

        TextField {
            id: passInput
            placeholderText: "Password"
            echoMode: TextInput.Password
            visible: true // Hide until needed
            color: "#ebdbb2"
            background: Rectangle { color: "#3c3836" }
            Layout.fillWidth: true

            onAccepted: {
                messageText.text = "Starting session for " + userInput.text
                userInput.visible = false
                passInput.visible = false
                Greetd.createSession(userInput.text)
            }
        }
    }

    // --- Greetd Logic ---
    Connections {
        target: Greetd

        // Greetd is asking for info (e.g., "Password:")
        function onAuthMessage(message, error, responseRequired, echoResponse) {
            messageText.text = message
            
            if (responseRequired) {
                Greetd.respond(passInput.text)
            } else if (!error) {
                Greetd.respond("")
            }
        }

        // Authentication failed (wrong password)
        function onAuthFailure(message) {
            messageText.text = "Login failed: " + message
            passInput.visible = true
            userInput.visible = true // Show username field again
            userInput.text = ""
            passInput.text = ""
            userInput.forceActiveFocus()
        }

        // Authentication succeeded!
        function onReadyToLaunch() {
            messageText.text = "Success! Launching session..."
            
            // --- IMPORTANT ---
            // Change "sway" to your desired session command
            // e.g., "Hyprland", "startplasma-wayland", or just "bash"
            Greetd.launch(["startplasma-wayland"])
        }
    }

    // Start by focusing the username input
    Component.onCompleted: {
        userInput.forceActiveFocus()
    }
}
