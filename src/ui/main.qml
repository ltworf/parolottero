import QtQuick 2.15
import QtQuick.Window 2.15


import QtQuick.Controls 2.15


Window {
    width: 640
    height: 480
    visible: true
    title: qsTr("Parolottero")

    LangSelector {
        id: language_selector
        height: parent.height
        width: parent.width
        visible: language == null
    }

}
