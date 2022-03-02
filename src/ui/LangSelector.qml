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
import QtQuick.Controls 2.15
import QtQuick.Layouts 1.12

ColumnLayout{
    property int language_index: -1
    property alias seed: spinseed.value
    property alias use_seed: switchseed.checked
    property alias duration: durationspin.value
    spacing: 2

    ListView {
        Layout.alignment: Qt.AlignLeft
        Layout.fillHeight: true
        Layout.fillWidth: true

        model: items

        header: Label {
            font.pointSize: 25
            text: qsTr("Pick a language")
            width: parent.width
            horizontalAlignment: Text.AlignHCenter
        }

        ListModel {
            id: items
        }

        delegate: Button {
            width: parent.width
            text: name
            onClicked: {
                language_index = index
            }
        }
    }

    GridLayout {
        Layout.fillWidth: true
        Layout.alignment: Qt.AlignBottom
        columns: 2

        Switch {
            Layout.columnSpan: 2
            Layout.fillWidth: true
            LayoutMirroring.enabled: true
            text: qsTr("User defined seed")
            id: switchseed
        }

        Label {
            text: qsTr("Seed")
            Layout.fillWidth: true
        }

        SpinBox {
            id: spinseed
            from: 1
            to: 10000
            editable: true
            enabled: switchseed.checked
        }

        Label {
            text: qsTr("Duration")
            Layout.fillWidth: true
        }

        SpinBox {
            id: durationspin
            from: 1
            to: 10
            editable: true
        }

    }

    Component.onCompleted: {
        items.clear()
        var languages = languageManager.languages();
        for(var i = 0; i < languages.length; i++) {
            items.append({name: languages[i], index: i})
        }
    }
}
