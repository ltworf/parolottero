import QtQuick 2.0
import QtQuick.Layouts 1.15
import QtQuick.Controls 2.15

import ltworf.parolottero 1.0

Item {
    property int language_id: -1
    property bool playable: board.playable

    onLanguage_idChanged: {
        // This should not be necessary but it is
        // Probably a bug I do not understand
        board.language = language_id
    }

    onPlayableChanged: {
        items.clear();
        if (! playable) {
            return;
        }

        for (var i=0; i<16; i++) {
            items.append({index: i, name: board.get_letter(i), multiplier: board.get_multiplier(i)})
        }
    }

    BoardManager {
        id: board
        seed: 0
        language: -1
    }

    ListModel {
        id: items
    }

    GridView {
        anchors.fill: parent
        cellWidth: 100; cellHeight: 100
        focus: true
        model: items

        highlight: Rectangle { width: 80; height: 80; color: "lightsteelblue" }

        delegate: Item {
            width: 100; height: 100

            Text {
                id: myIcon
                text: multiplier + " " + index
                y: 20; anchors.horizontalCenter: parent.horizontalCenter
            }
            Text {
                anchors { top: myIcon.bottom; horizontalCenter: parent.horizontalCenter }
                text: name
            }
            MouseArea {
                anchors.fill: parent
                onClicked: parent.GridView.view.currentIndex = index
            }
        }
        footer: Label {text: qsTr("Total: ") + board.total}
    }
}
