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

#include "scoreboard.h"

Scoreboard::Scoreboard(QObject *parent)
    : QObject{parent}
{

}

void Scoreboard::clear() {
    for (int i = 0; i < items.size(); i++) {
        delete items[i];
    }
    this->items.clear();
    emit this->size_changed(0);
}

/**
 * @brief Scoreboard::addWord
 *
 * Adds the word to the list, sorting by points
 *
 * @param word
 * @param points
 */
void Scoreboard::addWord(QString word, unsigned int points) {
    int i;
    for (i = 0; i < items.size(); i++) {
        if (points > this->items[i]->get_points())
            break;
    }

    this->items.insert(i, new ScoreboardItem(word, points, this));
    emit this->size_changed(this->items.size());
}

unsigned int Scoreboard::get_size() {
    return this->items.size();
}

QString Scoreboard::get_word(unsigned int i) {
    return this->items[i]->get_word();
}

unsigned int Scoreboard::get_points(unsigned int i) {
    return this->items[i]->get_points();
}
