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
import QtQuick.Window 2.15
import Qt.labs.settings 1.1
import QtQuick.Controls 2.15


Window {
    visible: true
    title: qsTr("Parolottero")
    id: main_window

    SystemPalette {
        id: palette
    }
    color: palette.base

    LangSelector {
        id: language_selector
        anchors.fill: parent
        visible: !board.match_in_progress
    }

    PlayBoard {
        id: board
        anchors.fill: parent
        language_id: language_selector.language_index
        visible: board.match_in_progress
        seed: language_selector.seed
        use_seed: language_selector.use_seed
        duration: language_selector.duration

        onMatch_in_progressChanged: {
            // Reset language index after a match
            if (board.match_in_progress == false)
                language_selector.language_index = -1
        }
    }

    Settings {
        id: settings
        property alias duration: language_selector.duration
        property alias seed: language_selector.seed
        property alias use_seed: language_selector.use_seed
        property alias x: main_window.x
        property alias y: main_window.y
        property alias width: main_window.width
        property alias height: main_window.height
    }
}
