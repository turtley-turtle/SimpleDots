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
    property int currentUser: userModel.lastIndex
    property int usernameRole: Qt.UserRole + 1
    property int realNameRole: Qt.UserRole + 2
    property int avatarRole: Qt.UserRole + 3

    Connections {
        target: sddm

        onLoginSucceeded: {
            errorMessage.color = config.textColor
            errorMessage.text = ""
        }

        onLoginFailed: {
            password.text = ""
            errorMessage.color = config.errorColor
            errorMessage.text = config.wrongPass
            errorMessage.font = config.textFont
        }

        onInformationMessage: {
            errorMessage.color = config.textColor
            errorMessage.text = message
            errorMessage.font = config.textFont
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

    // debug
    //Text {
    //    anchors.top: parent.top
    //    anchors.horizontalCenter: parent.horizontalCenter
    //    color: "white"
    //    font.pixelSize: 24
    //    text: (userModel.data(0, avatarRole) || "undefined ") + (userModel.data(0, usernameRole) || "undefined ") + (userModel.data(0, realNameRole) || "undefined") 
    //}

    Column {
        anchors.bottom: parent.bottom
        anchors.horizontalCenter: parent.horizontalCenter
        anchors.bottomMargin: 16
        spacing: config.avatarSpacing
        Repeater {
            model: userModel
            delegate: BetterImage {
                width: config.avatarSize
                height: config.avatarSize
                radius: config.avatarRadius
                borderColor: index === currentUser ? config.avatarActiveBorderColor : config.avatarBorderColor
                source: userModel.data(index, avatarRole)

                MouseArea {
                    anchors.fill: parent
                    onClicked: currentUser = index
                }
            }
        }
    }

    Rectangle {
        anchors.fill: parent
        color: "transparent"

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
        password.text = ""
        sddm.login(
            userModel.data(currentUser, usernameRole),
            password.text,
            sessionIndex
        )
    }
    Component.onCompleted: password.forceActiveFocus()
}

//unfinished whatever whatever