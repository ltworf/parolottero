import QtQuick 2.15
import QtQuick.Window 2.15
import Qt.labs.settings 1.1
import QtQuick.Controls 2.15


Window {
    visible: true
    title: qsTr("Parolottero")
    id: main_window

    LangSelector {
        id: language_selector
        height: parent.height
        width: parent.width
        visible: language_index < 0
    }

    Settings {
        property alias x: main_window.x
        property alias y: main_window.y
        property alias width: main_window.width
        property alias height: main_window.height
    }
}
