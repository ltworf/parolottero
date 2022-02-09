import QtQuick 2.15
import QtQuick.Layouts 1.15
import QtQuick.Controls 2.15

import ltworf.parolottero 1.0

Item {
    property alias language_id: board.language
    property alias playable: board.playable
    property alias seed: board.seed
    property int duration: 3

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
        property int seconds_left: -1

        id: board
        language: -1
    }

    Timer {
        interval: 1000
        repeat: true
        running: board.seconds_left > 0
        onTriggered: board.seconds_left--
    }

    ListModel {
        id: items
    }

    GridView {
        id: grid
        anchors.fill: parent
        cellWidth: width / 4
        cellHeight: cellWidth
        model: items
        interactive: false
        currentIndex: -1

        highlight: Rectangle {
            width: grid.cellWidth
            height: width
            color: "lightsteelblue"
        }

        delegate: LetterCell {
            width: grid.cellWidth * 0.7
            height: width
            text: name.toUpperCase()
            multiplier: cell_multiplier
        }

        header: RowLayout {
            width: parent.width
            leftMargin: 5
            rightMargin: 5
            Label {
                text: board.last_word
                color: board.last_score ? "green" : "red"
                font.pointSize: 30
                Layout.fillWidth: true
            }

            Text {
                text: board.seconds_left
                color: board.seconds_left > 60 ? "green" : (board.seconds_left > 30? "yellow": "red")
                font.pointSize: 40
            }

            Rectangle {
                color: board.seconds_left > 60 ? "green" : (board.seconds_left > 30? "yellow": "red")
                radius: 10
                Layout.preferredHeight: 30
                Layout.preferredWidth: 30
            }
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

                if (board.seconds_left == 0)
                    return;
                else if (board.seconds_left == -1)
                    board.seconds_left = duration * 60

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

                if (mouse.buttons == 0 || board.seconds_left == 0)
                    return;

                var index = find_item_index(mouse.x, mouse.y);
                if (index < 0 || grid.itemAtIndex(index).used)
                    return;
                if (! board.are_adjacent(index, board.current_word_indexes[board.current_word_indexes.length - 1]))
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
