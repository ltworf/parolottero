/*
parolottero
Copyright (C) 2022 Salvo "LtWorf" Tomaselli

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

GradientRect {

    ColumnLayout {
        anchors.fill: parent
        spacing: 20

        Item {Layout.fillHeight: true}

        Label {
            font.pointSize: 30
            text: qsTr("Parolottero")
            Layout.fillWidth: true
            horizontalAlignment: Text.AlignHCenter
        }

        Label {
            font.pointSize: 15
            text: qsTr("Released under AGPL-3")
            Layout.margins: 10
        }

        Label {
            font.pointSize: 10
            text: '© 2021-2022 Salvo "LtWorf" Tomaselli <br>&lt;<a href="mailto:tiposchi@tiscali.it">tiposchi@tiscali.it</a>&gt;'
            Layout.margins: 5
            onLinkActivated:Qt.openUrlExternally(link);
        }

        Label {
            font.pointSize: 15
            text: qsTr('<a href="https://github.com/ltworf/parolottero">Website</a>')
            Layout.margins: 10
            onLinkActivated:Qt.openUrlExternally(link);
        }

        Button {
            text: qsTr("Done")
            Layout.fillWidth: true
            Layout.margins: 10
            onClicked: parent.parent.visible = false
        }

        Item {Layout.fillHeight: true}
    }
}
