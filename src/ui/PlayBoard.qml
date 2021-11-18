import QtQuick 2.15
import QtQuick.Layouts 1.15
import QtQuick.Controls 2.15

import ltworf.parolottero 1.0

Item {
    property int language_id: -1
    property bool playable: board.playable

    property string current_word: ""

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
        id: grid
        anchors.fill: parent
        cellWidth: 100; cellHeight: 100
        focus: true
        model: items
        interactive: false
        currentIndex: -1

        highlight: Rectangle { width: 100; height: 100; color: "lightsteelblue" }

        MouseArea {
            anchors.fill: parent
            hoverEnabled: true

            onPositionChanged : {
                if (mouse.buttons == 0)
                    return;
                mouse.accepted = true

                for (var i=0; i < 16; i++) {
                    var item = grid.itemAtIndex(i);
                    var point = mapToItem(item, mouse.x, mouse.y);
                    if (item.contains(point))
                        console.debug(i)
                }

            }
        }

        delegate: Rectangle {
            width: 80; height: 80
            border.width: 3
            color: "transparent"

            Text {
                id: myIcon
                text: multiplier
                y: 20; anchors.horizontalCenter: parent.horizontalCenter
            }
            Text {
                anchors { top: myIcon.bottom; horizontalCenter: parent.horizontalCenter }
                text: name.toUpperCase()
            }

        }
        header: Label {text: current_word}
        footer: Label {text: qsTr("Total: ") + board.total}
    }
}
