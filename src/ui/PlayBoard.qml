/*
parolottero
Copyright (C) 2021-2022 Salvo "LtWorf" Tomaselli

This program is free software: you can redistribute it and/or modify
it under the terms of the GNU Affero General Public License as
published by the Free Software Foundation, either version 3 of the
License, or (at your option) any later version.

This program is distributed in the hope that it will be useful,
but WITHOUT ANY WARRANTY; without even the implied warranty of
MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
GNU Affero General Public License for more details.

You should have received a copy of the GNU Affero General Public License
along with this program.  If not, see <https://www.gnu.org/licenses/>.

author Salvo "LtWorf" Tomaselli <tiposchi@tiscali.it>
*/

import QtQuick 2.15
import QtQuick.Layouts 1.15
import QtQuick.Controls 2.15

import ltworf.parolottero 1.0

Item {
    property alias language_id: board.language
    property alias playable: board.playable
    property alias seed: board.seed
    property alias use_seed: board.use_seed
    property int duration: 3
    property bool match_in_progress: false

    onPlayableChanged: {
        items.clear();
        if (! playable) {
            return;
        }

        match_in_progress = true

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

    ColumnLayout {
        anchors.fill: parent

        RowLayout {
            width: parent.width
            id: header

            Button {
                text: qsTr("←")
                onClicked: {
                    board.last_word = ""
                    board.current_word_indexes = []
                    board.last_score = 0
                    board.seconds_left = -1
                    match_in_progress = false
                    grid.visible = true
                    scoreboard.visible = false
                }
            }

            Button {
                text: qsTr("Scores")
                visible: board.seconds_left == 0
                onClicked: {
                    // Update the scoreboard just if we are about to show it
                    if (!scoreboard.visible) {
                        scores.clear()
                        for (var i=0; i < board.scoreboard.size; i++) {
                            scores.append({word: board.scoreboard.get_word(i), points: board.scoreboard.get_points(i)})
                        }
                    }
                    grid.visible = ! grid.visible
                    scoreboard.visible = ! scoreboard.visible
                }
            }

            Item {
                Layout.fillWidth: true
            }

            Text {
                id: time_label
                text: board.seconds_left
                color: board.seconds_left > 60 ? "green" : (board.seconds_left > 30? "yellow": "red")
                font.pointSize: 40
            }

            Rectangle {
                color: time_label.color
                radius: 10
                Layout.preferredHeight: 30
                Layout.preferredWidth: 30
                Layout.rightMargin: 15
            }
        }

        Label {
            text: board.last_word
            color: board.last_score ? "green" : "red"
            font.pointSize: 30
            Layout.fillWidth: true
            visible: grid.visible
        }

        ListView {
            id: scoreboard
            visible: false
            Layout.alignment: Qt.AlignLeft
            Layout.fillHeight: true
            Layout.fillWidth: true
            Layout.margins: 5

            model: scores

            ListModel {
                id: scores
            }

            delegate: RowLayout {
                Label {
                    text: points
                    color: points ? "green": "red"
                    font.pointSize: 24
                }
                Label {
                    text: word
                    color: points ? "green": "red"
                    width: height * 2
                    font.pointSize: 24
                }
            }
        }

        GridView {
            id: grid
            Layout.preferredWidth: parent.width - 20 // 20 is the margin
            Layout.preferredHeight: width
            Layout.minimumWidth: 4 * 80
            Layout.minimumHeight: 4 * 80
            Layout.leftMargin: 20
            //Layout.maximumHeight: parent.height - footer.height - header.height

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

            MouseArea {
                anchors.fill: parent
                hoverEnabled: true

                onPressed: {
                    mouse.accepted = false;

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
                    mouse.accepted = true;
                }

                onReleased: {
                    mouse.accepted = board.seconds_left > 0;
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

        Item {
            Layout.fillHeight: true
            visible: grid.visible
        }

        RowLayout {
            id: footer
            width: parent.width

            Label {
                text: qsTr("Total: ") + board.total
                font.pointSize: 30
            }
        }
    }
}
