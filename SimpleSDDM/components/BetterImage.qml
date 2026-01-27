import QtQuick 2.0
import SddmComponents 2.0
import QtGraphicalEffects 1.15

Item {
    id: bimg
    property string source
    property int radius: 10
    property color borderColor: "#000000"
    property int border: 3
    width: 64
    height: 64

    Rectangle {
        id: border
        width: bimg.width + 2*bimg.border
        height: bimg.height + 2*bimg.border
        color: bimg.borderColor
        radius: bimg.radius
        anchors.centerIn: parent

        Image {
            source: bimg.source
            width: bimg.width
            height: bimg.height
            anchors.centerIn: parent
            layer.enabled: true
            layer.effect: OpacityMask {
                maskSource: Item {
                    anchors.centerIn: parent
                    width: bimg.width
                    height: bimg.height
                    Rectangle {
                        anchors.centerIn: parent
                        width: bimg.width
                        height: bimg.height
                        radius: bimg.radius
                        color: bimg.borderColor
                    }
                }
            }
        }
    }
}