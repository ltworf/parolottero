import QtQuick 2.15
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

        for (var i=0; i < board.size; i++) {
            items.append({index: i, name: board.get_letter(i), multiplier: board.get_multiplier(i)})
        }
    }

    BoardManager {
        property string current_word: ""
        property var current_word_indexes: []

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

            onPressed: {
                mouse.accepted = true;

                var index = find_item_index(mouse.x, mouse.y);
                if (index < 0)
                    return;

                board.current_word += items.get(index).name
                board.current_word_indexes.push(index);
                grid.currentIndex = index;
                grid.itemAtIndex(index).used = true;
            }

            onReleased: {
                mouse.accepted = true;
                console.log(board.current_word);
                console.log(board.current_word_indexes);
                for (var i = 0; i < board.size; i++) {
                    grid.itemAtIndex(i).used = false;
                }
                board.input_word(board.current_word_indexes);
                grid.currentIndex = -1;
                board.current_word = "";
                board.current_word_indexes = [];
            }

            onPositionChanged : {
                mouse.accepted = true;

                if (mouse.buttons == 0)
                    return;

                var index = find_item_index(mouse.x, mouse.y);
                if (index < 0 || grid.itemAtIndex(index).used)
                    return;
                grid.itemAtIndex(index).used = true;
                grid.currentIndex = index;
                board.current_word += items.get(index).name;
                board.current_word_indexes.push(index);
            }

            function find_item_index(x, y) {
                for (var i=0; i < board.size; i++) {
                    var item = grid.itemAtIndex(i);
                    var point = mapToItem(item, x, y);
                    if (item.contains(point))
                        return i;
                }
                return -1;
            }
        }

        delegate: Rectangle {
            property bool used: false
            width: 80; height: 80
            border.width: 3
            color: used ? "gray": "transparent"

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
        header: Label {text: board.current_word}
        footer: Label {text: qsTr("Total: ") + board.total}
    }
}
