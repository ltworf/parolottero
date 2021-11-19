import QtQuick 2.15

Rectangle {
    property bool used: false
    property int multiplier: 1
    property string text: ""
    border.width: 3
    border.color: (multiplier == 1) ? "light gray" : ((multiplier == 2) ? "yellow": "red")
    color: used ? "gray": "transparent"

    Text {
        anchors.centerIn: parent
        text: name.toUpperCase()
        font.pointSize: 40
    }
}
