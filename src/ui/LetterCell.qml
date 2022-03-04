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

Rectangle {
    property bool used: false
    property int multiplier: 1
    property string text: ""
    border.width: 3

    border.color: (multiplier == 1) ? "light steel blue" : ((multiplier == 2) ? "gold": "pink")

    gradient: Gradient {
        GradientStop { position: 0.0; color: used ? "steel blue": border.color }
        GradientStop { position: 1.0; color: used ? "light gray": "white" }
    }

    Text {
        anchors.centerIn: parent
        text: name.toUpperCase()
        font.pointSize: 40
    }
}
