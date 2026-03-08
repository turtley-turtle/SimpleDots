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

    property int sessionIndex: sessionModel.lastIndex
    property int currentUser: 0
    property string currentUsername: userModel.lastUser
    property int sessionNameRole: Qt.UserRole + 4
    property int avatarRole: Qt.UserRole + 3
    property int realNameRole: Qt.UserRole + 2
    property int usernameRole: Qt.UserRole + 1

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

    Timer {
        interval: 1000
        running: true
        repeat: true
        onTriggered: date.text = Qt.formatDateTime(new Date(), "ddd, MMM d yyyy")
    }

    Timer {
        interval: 1000
        running: true
        repeat: true
        onTriggered: clock.text = Qt.formatDateTime(new Date(), "HH:mm")
    }

    

    Column {
        anchors.horizontalCenter: parent.horizontalCenter
        anchors.verticalCenter: parent.verticalCenter
        spacing: 20
        Row {
            spacing: 20
            anchors.horizontalCenter: parent.horizontalCenter

            Text {
                text: "<"
                font.family: config.textFont
                font.pixelSize: avatar.height / 2
                anchors.verticalCenter: parent.verticalCenter
                color: config.textColor

                MouseArea {
                    cursorShape: Qt.PointingHandCursor
                    anchors.fill: parent
                    onClicked: {
                        if (userModel.count > 0) {
                            root.currentUser = (root.currentUser - 1 + userModel.count) % userModel.count
                            root.currentUsername = userModel.data(userModel.index(root.currentUser, 0), root.usernameRole)
                        }
                    }
                }
            }

            BetterImage {
                id: avatar
                width: config.avatarSize
                height: config.avatarSize
                radius: config.avatarRadius
                borderColor: config.avatarBorderColor
                border: config.avatarBorderSize
                source: userModel.data(userModel.index(root.currentUser, 0), root.avatarRole).icon ? userModel.data(userModel.index(root.currentUser, 0), root.avatarRole) : "/usr/share/sddm/faces/" + userModel.data(userModel.index(root.currentUser, 0), root.usernameRole) + ".face.icon"
            }

            Text {
                text: ">"
                font.family: config.textFont
                font.pixelSize: avatar.height / 2
                anchors.verticalCenter: parent.verticalCenter
                color: config.textColor

                MouseArea {
                    cursorShape: Qt.PointingHandCursor
                    anchors.fill: parent
                    onClicked: {
                        if (userModel.count > 0) {
                            root.currentUser = (root.currentUser + 1) % userModel.count
                            root.currentUsername = userModel.data(userModel.index(root.currentUser, 0), usernameRole)
                        }
                    }
                }
            }
        }

        Text {
            text: userModel.data(userModel.index(root.currentUser, 0), realNameRole) ? userModel.data(userModel.index(root.currentUser, 0), realNameRole) : root.currentUsername
            color: config.textColor
            font.pixelSize: config.nameSize
            font.family: config.textFont
            anchors.horizontalCenter: parent.horizontalCenter
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
            //anchors.verticalCenter: parent.verticalCenter
            //anchors.right: parent.right
            //anchors.rightMargin: 50
            background: Rectangle {
                color: config.inputColor
                radius: config.inputRadius
                border.width: config.inputBorder
                border.color: config.inputBorderColor
            }
        }
    }

    Row {
        anchors.horizontalCenter: parent.horizontalCenter
        anchors.bottom: parent.bottom
        spacing: 20

        Text {
            text: "<"
            font.family: config.textFont
            font.pixelSize: config.sessionSize
            color: config.textColor

            MouseArea {
                anchors.fill: parent
                cursorShape: Qt.PointingHandCursor
                onClicked: {
                    if (sessionModel.count > 0) {
                        sessionIndex = (sessionIndex - 1 + sessionModel.count) % sessionModel.count
                        session.text = sessionModel.data(sessionModel.index(root.sessionIndex, 0), sessionNameRole)
                    }
                }
            }
        }

        Text {
            id: session
            text: sessionModel.data(sessionModel.index(root.sessionIndex, 0), sessionNameRole)
            font.family: config.textFont
            font.pixelSize: config.sessionSize
            color: config.textColor
        }

        Text {
            text: ">"
            font.family: config.textFont
            font.pixelSize: config.sessionSize
            color: config.textColor

            MouseArea {
                anchors.fill: parent
                cursorShape: Qt.PointingHandCursor
                onClicked: {
                    if (sessionModel.count > 0) {
                        sessionIndex = (sessionIndex + 1) % sessionModel.count
                        session.text = sessionModel.data(sessionModel.index(root.sessionIndex, 0), sessionNameRole)
                    }
                }
            }
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
