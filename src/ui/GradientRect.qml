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

/*
 * Faded transparent rectangle that goes on top of stuff
 */
Rectangle {
    gradient: Gradient {
        GradientStop { position: 0.0; color: palette.base }
        GradientStop { position: 0.2; color: "#994682B4" }
        GradientStop { position: 0.8; color: "#AAAAAAAA" }
        GradientStop { position: 1.0; color: palette.base }
    }

    SystemPalette {
        id: palette
    }
    z: 1
}
