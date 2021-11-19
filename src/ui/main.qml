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
        anchors.fill: parent
        visible: !board.playable
    }

    PlayBoard {
        id: board
        anchors.fill: parent
        language_id: language_selector.language_index
        visible: board.playable
        seed: language_selector.seed
        duration: language_selector.duration
    }

    Settings {
        id: settings
        property alias duration: language_selector.duration
        property alias seed: language_selector.seed
        property alias x: main_window.x
        property alias y: main_window.y
        property alias width: main_window.width
        property alias height: main_window.height
    }
}
