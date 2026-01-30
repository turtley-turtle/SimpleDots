import QtQuick 2.0
import QtQuick.Controls 2.15
import SddmComponents 2.0
import QtGraphicalEffects 1.15
import "components"

Rectangle {
    id: root
    width: 1366
    height: 768

    LayoutMirroring.enabled: Qt.locale().textDirection == Qt.RightToLeft
    LayoutMirroring.childrenInherit: true

    property int sessionIndex: session.index
    property int currentUser: 0
    property string currentUsername: userModel.lastUser

    Connections {
        target: sddm

        onLoginFailed: {
            password.placeholderText = config.wrongPass
            password.placeholderTextColor = config.errorColor
            password.background.border.color = config.errorColor
            backtonormal.running = true
            password.text = ""
        }
    }

    Background {
        id: bg
        anchors.fill: parent
        source: config.background
        fillMode: Image.PreserveAspectCrop

        onStatusChanged: {
            if (status == Image.Error && source != config.defaultBackground) {
                source = config.defaultBackground
            }
        }
    }

    FastBlur {
        anchors.fill: bg
        source: bg
        radius: config.bgBlur
    }

    /* debug
    Text {
        id: debug
        property bool foundUsers: userModel.count > 0
        anchors.top: parent.top
        anchors.horizontalCenter: parent.horizontalCenter
        color: "white"
        font.pixelSize: 24
        text: currentUsername || "undefined"
    }

    Timer {
        interval: 250
        running: true
        onTriggered: {
            debug.text = currentUsername || "undefined"
            if (currentUsername == "") {
                debug.text = "undefined"
            }
        }
    }
    // debug end */

    Column {
        anchors.bottom: parent.bottom
        anchors.horizontalCenter: parent.horizontalCenter
        anchors.bottomMargin: 16
        spacing: config.avatarSpacing
        Repeater {
            id: users
            model: userModel
            delegate: BetterImage {
                width: config.avatarSize
                height: config.avatarSize
                radius: config.avatarRadius
                borderColor: index === currentUser ? config.avatarActiveBorderColor : config.avatarBorderColor
                source: model.icon ? model.icon : "/usr/share/sddm/faces/" + model.name + ".face.icon"

                MouseArea {
                    anchors.fill: parent
                    cursorShape: Qt.PointingHandCursor
                    onClicked: {
                        root.currentUser = index
                        root.currentUsername = model.name
                    }
                }
            }
        }
    }

    Text {
        id: clock
        text: Qt.formatDateTime(new Date(), "HH:MM")
        color: config.textColor
        font.family: config.textFont
        font.pixelSize: config.clockSize
        font.bold: true
        anchors.centerIn: parent
        anchors.verticalCenterOffset: -120
    }

    Timer {
        interval: 1000
        running: true
        repeat: true
        onTriggered: clock.text = Qt.formatDateTime(new Date(), "HH:mm")
    }

    Text {
        id: date
        text: Qt.formatDateTime(new Date(), "ddd, MMM d yyyy")
        color: config.textColor
        font.family: config.textFont
        font.pixelSize: config.dateSize
        font.bold: true
        anchors.centerIn: parent
    }

    Timer {
        interval: 1000
        running: true
        repeat: true
        onTriggered: date.text = Qt.formatDateTime(new Date(), "ddd, MMM d yyyy")
    }
    
    TextField {
        id: password
        color: config.textColor
        placeholderTextColor: config.textColor
        font.family: config.textFont
        font.pixelSize: 20
        echoMode: TextInput.Password
        placeholderText: "Password"
        width: 270
        height: 60
        anchors.centerIn: parent
        anchors.verticalCenterOffset: 100
        anchors.horizontalCenterOffset: 0
        background: Rectangle {
            color: config.inputColor
            radius: config.inputRadius
            border.width: config.inputBorder
            border.color: config.inputBorderColor
        }
    }
    Keys.onReturnPressed: {
        password.background.border.color = config.loggingInColor
        sddm.login(
            currentUsername,
            password.text,
            sessionIndex
        )
    }
    Component.onCompleted: {
        password.forceActiveFocus()
        if (userModel.count > 0) {
            currentUser = 0
            currentUsername = userModel.lastUser
        }
    }

    Timer {
        id: backtonormal
        interval: 2000
        running: false
        repeat: false
        onTriggered: {
            password.placeholderText = "Password"
            password.placeholderTextColor = config.textColor
            password.background.border.color = config.inputBorderColor
        }
    }
}
