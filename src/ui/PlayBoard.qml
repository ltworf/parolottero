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
            items.append({index: i, name: board.get_letter(i), cell_multiplier: board.get_multiplier(i)})
        }
    }

    BoardManager {
        property string last_word: ""
        property var current_word_indexes: []
        property int last_score: 0

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

        delegate: LetterCell {
            width: 80; height: 80
            text: name.toUpperCase()
            multiplier: cell_multiplier
        }

        header: Text {
                text: board.last_word
                color: board.last_score ? "green" : "red"
                font.pointSize: 30
        }

        footer: Label {
            text: qsTr("Total: ") + board.total
            font.pointSize: 30
        }

        MouseArea {
            anchors.fill: parent
            hoverEnabled: true

            onPressed: {
                mouse.accepted = true;

                var index = find_item_index(mouse.x, mouse.y);
                if (index < 0)
                    return;

                board.current_word_indexes = [index];
                grid.currentIndex = index;
                grid.itemAtIndex(index).used = true;
            }

            onReleased: {
                mouse.accepted = true;
                for (var i = 0; i < board.size; i++) {
                    grid.itemAtIndex(i).used = false;
                }
                board.last_score = board.input_word(board.current_word_indexes);

                var word = "";
                for (i=0; i < board.current_word_indexes.length; i++) {
                    word += items.get(board.current_word_indexes[i]).name;
                }
                board.last_word = word;

                grid.currentIndex = -1;
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

    }
}
