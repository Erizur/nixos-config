pragma ComponentBehavior

import QtQuick
import QtQuick.Layouts
import QtQuick.Controls
import QtQuick.Effects

import Quickshell
import Quickshell.Io
import Quickshell.Wayland
import Quickshell.Services.Greetd

import qs.Commons

ShellRoot {
  id: root

  // Config via environment variables
  readonly property string instant_auth: Quickshell.env("GREET_INSTANTAUTH")
  readonly property string preferred_session: Quickshell.env("GREET_PREF_SES")
  readonly property string preferred_user: Quickshell.env("GREET_PREF_USR")
  // Fallback to empty string and log later to avoid assigning console.log result
  readonly property string sessions: ""
  readonly property string wallpaper_path: Quickshell.env("GREET_WALLPATH")
  readonly property string userpic_path: Quickshell.env("GREET_UPICPATH")

  // Wallpaper state from noctalia config
  property string currentMonitorName: ""

  function authenticate() {
    Greetd.createSession(users.current_user)
  }

  Component.onCompleted: {
    if (sessions == "") {
      console.log("[WARN] empty sessions list, defaulting to KDE")
      sessions.current_session = "startplasma-wayland"
      sessions.current_session_name = "KDE Plasma"
    }
  }

  // Main greeter interface
  WlSessionLock {
    id: sessionLock

    property string fakeBuffer: ""
    property string passwdBuffer: ""
    readonly property bool unlocking: Greetd.state == GreetdState.Authenticating

    locked: true

    WlSessionLockSurface {
      // Background with wallpaper and gradient overlay
      Rectangle {
        anchors.fill: parent
        color: Colors.mSurface

        // Wallpaper - prioritize noctalia config, fallback to environment variable
        Image {
          anchors.fill: parent
          source: root.wallpaper_path
          fillMode: Image.PreserveAspectCrop
          visible: root.wallpaper_path !== ""

          onStatusChanged: {
            if (status === Image.Error) {
              console.log("[ERROR] Failed to load wallpaper:", source)
            } else if (status === Image.Ready) {
              console.log("[INFO] Successfully loaded wallpaper:", source)
            }
          }
        }

        // Gradient overlay similar to your lockscreen
        Rectangle {
          anchors.fill: parent
          gradient: Gradient {
            GradientStop {
              color: Qt.rgba(0, 0, 0, 0.6)
              position: 0.0
            }
            GradientStop {
              color: Qt.rgba(0, 0, 0, 0.3)
              position: 0.3
            }
            GradientStop {
              color: Qt.rgba(0, 0, 0, 0.4)
              position: 0.7
            }
            GradientStop {
              color: Qt.rgba(0, 0, 0, 0.7)
              position: 1.0
            }
          }
        }

        // Animated particles like your lockscreen
        Repeater {
          model: 20
          Rectangle {
            width: Math.random() * 4 + 2
            height: width
            radius: width * 0.5
            color: Colors.applyOpacity(Colors.mPrimary, "4D")
            x: Math.random() * parent.width
            y: Math.random() * parent.height

            SequentialAnimation on opacity {
              loops: Animation.Infinite
              NumberAnimation {
                to: 0.8
                duration: 2000 + Math.random() * 3000
              }
              NumberAnimation {
                to: 0.1
                duration: 2000 + Math.random() * 3000
              }
            }
          }
        }
      }

      Item {
        anchors.fill: parent

        ColumnLayout {
          anchors.top: parent.top
          anchors.left: parent.left
          anchors.right: parent.right
          anchors.topMargin: 80
          spacing: 40

          // Time and Date display
          Column {
            spacing: 10
            Layout.alignment: Qt.AlignHCenter

            Text {
              id: timeText
              text: Qt.formatDateTime(new Date(), "HH:mm")
              font.family: "DejaVu Sans"
              font.pointSize: 72
              font.weight: Font.Bold
              color: Colors.mOnSurface
              horizontalAlignment: Text.AlignHCenter

              SequentialAnimation on scale {
                loops: Animation.Infinite
                NumberAnimation {
                  to: 1.02
                  duration: 2000
                  easing.type: Easing.InOutQuad
                }
                NumberAnimation {
                  to: 1.0
                  duration: 2000
                  easing.type: Easing.InOutQuad
                }
              }
            }

            Text {
              id: dateText
              text: Qt.formatDateTime(new Date(), "dddd, MMMM d")
              font.family: "DejaVu Sans"
              font.pointSize: 24
              font.weight: Font.Light
              color: Colors.mOnSurface
              horizontalAlignment: Text.AlignHCenter
              width: timeText.width
            }
          }

          // Centered circular avatar area
          Rectangle {
            width: 108
            height: 108
            radius: width * 0.5
            color: "transparent"
            border.color: Colors.mPrimary
            border.width: 2
            anchors.horizontalCenter: parent.horizontalCenter
            z: 10

            Rectangle {
              anchors.centerIn: parent
              width: parent.width + 24
              height: parent.height + 24
              radius: width * 0.5
              color: "transparent"
              border.color: Colors.applyOpacity(Colors.mPrimary, "4D")
              border.width: 1
              z: -1
              visible: !sessionLock.unlocking

              SequentialAnimation on scale {
                loops: Animation.Infinite
                NumberAnimation {
                  to: 1.1
                  duration: 1500
                  easing.type: Easing.InOutQuad
                }
                NumberAnimation {
                  to: 1.0
                  duration: 1500
                  easing.type: Easing.InOutQuad
                }
              }
            }

            // User avatar - use noctalia avatar with circular shader, fallback to initial
            Rectangle {
              anchors.centerIn: parent
              width: 100
              height: 100
              radius: width * 0.5
              color: Colors.mPrimary

              // Raw image used as texture source for the shader
              Image {
                id: avatarImage
                anchors.fill: parent
                source: root.userpic_path
                fillMode: Image.PreserveAspectCrop
                smooth: true
                visible: false

                onStatusChanged: {
                  if (status === Image.Error && root.userpic_path) {
                    console.log("[WARN] Failed to load avatar image:", root.userpic_path)
                  } else if (status === Image.Ready) {
                    console.log("[INFO] Successfully loaded avatar image:", root.userpic_path)
                  }
                }
              }

              // Circular mask shader effect
              ShaderEffect {
                anchors.fill: parent
                visible: avatarImage.status === Image.Ready
                property var source: avatarImage
                property real imageOpacity: 1.0
                fragmentShader: Qt.resolvedUrl("./Shaders/qsb/circled_image.frag.qsb")
              }

              // Fallback to initial letter if no avatar image
              Text {
                anchors.centerIn: parent
                text: users.current_user.charAt(0).toUpperCase()
                font.pointSize: 36
                font.bold: true
                color: Colors.mOnSurface
                visible: avatarImage.status !== Image.Ready
              }
            }

            MouseArea {
              anchors.fill: parent
              hoverEnabled: true
              onEntered: parent.scale = 1.05
              onExited: parent.scale = 1.0
              onClicked: users.next()
            }

            Behavior on scale {
              NumberAnimation {
                duration: 200
                easing.type: Easing.OutBack
              }
            }
          }

          // Session selector below avatar
          Rectangle {
            height: 40
            radius: 20
            color: "transparent"
            border.color: Colors.mPrimary
            border.width: 1
            anchors.horizontalCenter: parent.horizontalCenter

            // Make width depend on text length
            width: Math.max(180, sessionNameText.paintedWidth + 40)

            Text {
              id: sessionNameText
              anchors.centerIn: parent
              text: sessions.current_session_name.replace(/\(|\)/g, "")
              color: Colors.mOnSurface
              font.pointSize: 16
              font.bold: true
            }

            MouseArea {
              anchors.fill: parent
              onClicked: {
                sessions.next()
                // Persist selection (use identifier from exec or sanitized name)
              }
            }
          }
        }

        // Terminal-style input area
        Rectangle {
          id: terminalBackground
          width: 720
          height: 280
          anchors.centerIn: parent
          anchors.verticalCenterOffset: 50
          radius: 20
          color: Colors.applyOpacity(Colors.mSurface, "E6")
          border.color: Colors.mPrimary
          border.width: 2

          // Terminal scanlines effect
          Repeater {
            model: 20
            Rectangle {
              width: parent.width
              height: 1
              color: Colors.applyOpacity(Colors.mPrimary, "1A")
              y: index * 10
              opacity: 0.3
              SequentialAnimation on opacity {
                loops: Animation.Infinite
                NumberAnimation {
                  to: 0.6
                  duration: 2000 + Math.random() * 1000
                }
                NumberAnimation {
                  to: 0.1
                  duration: 2000 + Math.random() * 1000
                }
              }
            }
          }

          // Terminal header
          Rectangle {
            width: parent.width
            height: 40
            color: Colors.applyOpacity(Colors.mPrimary, "33")
            topLeftRadius: 18
            topRightRadius: 18

            RowLayout {
              anchors.fill: parent
              anchors.margins: 10
              spacing: 10

              Text {
                text: "SECURE TERMINAL"
                color: Colors.mOnSurface
                font.family: "DejaVu Sans Mono"
                font.pointSize: 14
                font.weight: Font.Bold
                Layout.fillWidth: true
              }

              Text {
                text: "USER: " + users.current_user
                color: Colors.mOnSurface
                font.family: "DejaVu Sans Mono"
                font.pointSize: 12
              }
            }
          }

          // Terminal content
          ColumnLayout {
            anchors.top: parent.top
            anchors.left: parent.left
            anchors.right: parent.right
            anchors.bottom: parent.bottom
            anchors.margins: 20
            anchors.topMargin: 55
            spacing: 15

            RowLayout {
              Layout.fillWidth: true
              spacing: 10

              Text {
                text: users.current_user + "@noctalia:~$"
                color: Colors.mPrimary
                font.family: "DejaVu Sans Mono"
                font.pointSize: 16
                font.weight: Font.Bold
              }

              Text {
                text: "sudo start-session"
                color: Colors.mOnSurface
                font.family: "DejaVu Sans Mono"
                font.pointSize: 16
              }

              // Visible password input (terminal style)
              TextInput {
                id: terminalPassword
                color: Colors.mOnSurface
                font.family: "DejaVu Sans Mono"
                font.pointSize: 16
                echoMode: TextInput.Password
                passwordCharacter: "*"
                passwordMaskDelay: 0
                focus: true
                text: sessionLock.passwdBuffer
                // Size to content for terminal look
                width: Math.max(1, contentWidth)
                selectByMouse: false

                Component.onCompleted: terminalPassword.forceActiveFocus()

                onTextChanged: sessionLock.passwdBuffer = text

                Keys.onPressed: kevent => {
                  if (kevent.key === Qt.Key_Enter || kevent.key === Qt.Key_Return) {
                    if (Greetd.state == GreetdState.Inactive) {
                      root.authenticate()
                      kevent.accepted = true
                    }
                  } else if (kevent.key === Qt.Key_Escape) {
                    sessionLock.passwdBuffer = ""
                    terminalPassword.text = ""
                    kevent.accepted = true
                  }
                }
              }
            }

            Text {
              text: sessionLock.unlocking ? "Authenticating..." : ""
              color: sessionLock.unlocking ? Colors.mPrimary : "transparent"
              font.family: "DejaVu Sans Mono"
              font.pointSize: 16
              Layout.fillWidth: true

              SequentialAnimation on opacity {
                running: sessionLock.unlocking
                loops: Animation.Infinite
                NumberAnimation {
                  to: 1.0
                  duration: 800
                }
                NumberAnimation {
                  to: 0.5
                  duration: 800
                }
              }
            }

            // Execute button
            Rectangle {
              width: 120
              height: 40
              radius: 10
              color: executeButtonArea.containsMouse ? Colors.mPrimary : Colors.applyOpacity(Colors.mPrimary, "33")
              border.color: Colors.mPrimary
              border.width: 1
              enabled: !sessionLock.unlocking
              Layout.alignment: Qt.AlignRight
              Layout.bottomMargin: -10

              Text {
                anchors.centerIn: parent
                text: sessionLock.unlocking ? "EXECUTING" : "EXECUTE"
                color: executeButtonArea.containsMouse ? Colors.mOnSurface : Colors.mPrimary
                font.family: "DejaVu Sans Mono"
                font.pointSize: 14
                font.weight: Font.Bold
              }

              MouseArea {
                id: executeButtonArea
                anchors.fill: parent
                hoverEnabled: true
                onClicked: root.authenticate()

                SequentialAnimation on scale {
                  running: executeButtonArea.containsMouse
                  NumberAnimation {
                    to: 1.05
                    duration: 200
                    easing.type: Easing.OutCubic
                  }
                }

                SequentialAnimation on scale {
                  running: !executeButtonArea.containsMouse
                  NumberAnimation {
                    to: 1.0
                    duration: 200
                    easing.type: Easing.OutCubic
                  }
                }
              }

              SequentialAnimation on scale {
                loops: Animation.Infinite
                running: sessionLock.unlocking
                NumberAnimation {
                  to: 1.02
                  duration: 600
                  easing.type: Easing.InOutQuad
                }
                NumberAnimation {
                  to: 1.0
                  duration: 600
                  easing.type: Easing.InOutQuad
                }
              }
            }
          }

          // Terminal border glow
          Rectangle {
            anchors.fill: parent
            radius: parent.radius
            color: "transparent"
            border.color: Colors.applyOpacity(Colors.mPrimary, "4D")
            border.width: 1
            z: -1

            SequentialAnimation on opacity {
              loops: Animation.Infinite
              NumberAnimation {
                to: 0.6
                duration: 2000
                easing.type: Easing.InOutQuad
              }
              NumberAnimation {
                to: 0.2
                duration: 2000
                easing.type: Easing.InOutQuad
              }
            }
          }
        }

        // Power buttons at bottom right
        Row {
          anchors.right: parent.right
          anchors.bottom: parent.bottom
          anchors.margins: 50
          spacing: 20

          Rectangle {
            width: 60
            height: 60
            radius: width * 0.5
            color: powerButtonArea.containsMouse ? Colors.mError : Colors.applyOpacity(Colors.mError, "33")
            border.color: Colors.mError
            border.width: 2

            Text {
              anchors.centerIn: parent
              text: "⏻"
              font.pointSize: 24
              color: powerButtonArea.containsMouse ? Colors.mOnSurface : Colors.mError
            }

            MouseArea {
              id: powerButtonArea
              anchors.fill: parent
              hoverEnabled: true
              onClicked: {
                console.log("Power off clicked")
              }
            }
          }

          Rectangle {
            width: 60
            height: 60
            radius: width * 0.5
            color: restartButtonArea.containsMouse ? Colors.mPrimary : Colors.applyOpacity(Colors.mPrimary, "33")
            border.color: Colors.mPrimary
            border.width: 2

            Text {
              anchors.centerIn: parent
              text: "↻"
              font.pointSize: 24
              color: restartButtonArea.containsMouse ? Colors.mOnSurface : Colors.mPrimary
            }

            MouseArea {
              id: restartButtonArea
              anchors.fill: parent
              hoverEnabled: true
              onClicked: {
                console.log("Reboot clicked")
              }
            }
          }

          Rectangle {
            width: 60
            height: 60
            radius: width * 0.5
            color: suspendButtonArea.containsMouse ? Colors.mSecondary : Colors.applyOpacity(Colors.mSecondary, "33")
            border.color: Colors.mSecondary
            border.width: 2

            Text {
              anchors.centerIn: parent
              text: "💤"
              font.pointSize: 20
              color: suspendButtonArea.containsMouse ? Colors.mOnSurface : Colors.mSecondary
            }

            MouseArea {
              id: suspendButtonArea
              anchors.fill: parent
              hoverEnabled: true
              onClicked: {
                console.log("Suspend clicked")
              }
            }
          }
        }
      }

      // Hidden password input (keeps key handling consistent)
      TextInput {
        id: passwordInput
        width: 0
        height: 0
        visible: false
        focus: true
        echoMode: TextInput.Password
        text: sessionLock.passwdBuffer

        onTextChanged: {
          sessionLock.passwdBuffer = text
        }

        Component.onCompleted: {
          passwordInput.forceActiveFocus()
        }

        Keys.onPressed: kevent => {
          if (kevent.key === Qt.Key_Enter || kevent.key === Qt.Key_Return) {
            if (Greetd.state == GreetdState.Inactive) {
              root.authenticate()
            }
            kevent.accepted = true
          }
        }
      }
    }
  }

  // Greetd connections
  Connections {
    target: Greetd

    function onAuthMessage(message, error, responseRequired, echoResponse) {
      console.log(
            "[GREETD] msg='" + message + "' err='" + error + "' resreq=" + responseRequired + " echo=" + echoResponse)

      if (responseRequired) {
        Greetd.respond(sessionLock.passwdBuffer)
        sessionLock.passwdBuffer = ""
        sessionLock.fakeBuffer = ""
        return
      }

      // Finger print support
      Greetd.respond("")
    }

    function onReadyToLaunch() {
      sessionLock.locked = false
      console.log("[GREETD EXEC] " + sessions.current_session)
      // Let greetd handle quitting to avoid compositor handoff glitches
      Greetd.launch(sessions.current_session.split(" "), [], true)
    }
  }

  // User management process
  Process {
    id: users

    property string current_user: users_list[current_user_index] ?? ""
    property int current_user_index: 0
    property list<string> users_list: []

    function next() {
      current_user_index = (current_user_index + 1) % users_list.length
    }

    command: ["awk", `BEGIN { FS = ":"} /\\/home/ { print $1 }`, "/etc/passwd"]
    running: true

    stderr: SplitParser {
      onRead: data => console.log("[ERR] " + data)
    }
    stdout: SplitParser {
      onRead: data => {
        console.log("[USERS] " + data)
        if (data == root.preferred_user) {
          console.log("[INFO] Found preferred user " + root.preferred_user)
          users.current_user_index = users.users_list.length
        }
        users.users_list.push(data)
      }
    }

    onExited: if (root.instant_auth && !users.running) {
      console.log("[USERS EXIT]")
      root.authenticate()
    }
  }

  // Session management process
  Process {
    id: sessions

    property int current_ses_index: 0
    property string current_session: session_execs[current_ses_index] ?? "startplasma-wayland"
    property string current_session_name: session_names[current_ses_index] ?? "KDE Plasma"
    property list<string> session_execs: []
    property list<string> session_names: []

    function next() {
      current_ses_index = (current_ses_index + 1) % session_execs.length
    }

    function moveToFront(index) {
      if (index <= 0 || index >= session_execs.length)
        return
      const exec = session_execs[index]
      const name = session_names[index]
      session_execs.splice(index, 1)
      session_names.splice(index, 1)
      session_execs.unshift(exec)
      session_names.unshift(name)
      current_ses_index = 0
    }

    command: [Qt.resolvedUrl("./scripts/session.sh"), root.sessions]
    running: true

    stderr: SplitParser {
      onRead: data => console.log("[ERR] " + data)
    }
    stdout: SplitParser {
      onRead: data => {
        const parsedData = data.split(",")
        console.log("[SESSIONS] " + parsedData[2])
        if (parsedData[0] == root.preferred_session) {
          console.log("[INFO] Found preferred session " + root.preferred_session)
          sessions.current_ses_index = sessions.session_names.length
        }
        sessions.session_names.push(parsedData[1])
        sessions.session_execs.push(parsedData[2])
      }
    }

    onExited: {
      if (root.instant_auth && !users.running) {
        console.log("[SESSIONS EXIT]")
        root.authenticate()
      }
    }
  }

  // Timer to update time
  Timer {
    interval: 1000
    running: true
    repeat: true
    onTriggered: {
      if (typeof timeText !== 'undefined' && timeText) {
        timeText.text = Qt.formatDateTime(new Date(), "HH:mm")
      }
      if (typeof dateText !== 'undefined' && dateText) {
        dateText.text = Qt.formatDateTime(new Date(), "dddd, MMMM d")
      }
    }
  }
}
