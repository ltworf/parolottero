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

#include "scoreboarditem.h"

ScoreboardItem::ScoreboardItem(QString word, unsigned int points, QObject *parent): QObject{parent} {
    this->word = word;
    this->points = points;
}


unsigned int ScoreboardItem::get_points() {
    return this->points;
}

QString ScoreboardItem::get_word() {
    return this->word;
}
