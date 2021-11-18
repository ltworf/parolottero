import QtQuick 2.0
import QtQuick.Layouts 1.15
import QtQuick.Controls 2.15

import ltworf.parolottero 1.0

ColumnLayout {

    property int language_id: -1
    property bool playable: board.playable

    onLanguage_idChanged: {
        // This should not be necessary but it is
        // Probably a bug I do not understand
        board.language = language_id
    }

    BoardManager {
        id: board
        seed: 0
        language: -1
    }


    GridLayout {
        columns: 4

        Button { text: "a"}
        Button { text: "a"}
        Button { text: "a"}
        Button { text: "a"}
        Button { text: "a"}
        Button { text: "a"}
        Button { text: "a"}
        Button { text: "a"}
    }

    Label {
        text: qsTr("Total: " + board.total)
    }
}
