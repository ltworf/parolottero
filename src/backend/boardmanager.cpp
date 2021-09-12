/*
parolottero
Copyright (C) 2021 Salvo "LtWorf" Tomaselli

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

#include <stdlib.h>
#include "boardmanager.h"

BoardManager::BoardManager(Language* language, unsigned int seed, QObject *parent) : QObject(parent)
{
    this->language = language;

    //init board
    //Give vowels double chances to appear
    QStringList morevowels = language->letters + language->vowels;
    int lcount = morevowels.size();
    for (int i = 0; i < 16; i++) {
        this->letters.append(morevowels[rand_r(&seed) % lcount]);
        unsigned int multiplier;
        switch (rand_r(&seed) % 10) {
            case 3:
                multiplier = 3;
                break;
            case 2:
                multiplier = 2;
                break;
            default:
                multiplier = 1;
                break;
        }

        this->multipliers.append(multiplier);
    }
}

/**
 * @brief BoardManager::input_word
 * @param cells
 * @return
 *
 * Pass moves to the board, which returns the score for the given
 * sequence.
 */
unsigned int BoardManager::input_word(QList<unsigned int> cells) {
    QString word;

    unsigned int score = 0;
    for (int i = 0; i < cells.size(); i++) {
        word += this->letters[i];
        score += this->language->get_score(this->letters[i]) * this->multipliers[i];
    }
    if (this->language->is_word(word)) {
        this->total += score;
        this->words.append(word);
        return score;
    }
    return 0;
}

unsigned int BoardManager::get_total() {
    return this->total;
}

unsigned int BoardManager::get_multiplier(unsigned int cell) {
    return this->multipliers[cell];
}

QString BoardManager::get_letter(unsigned int cell) {
    return this->letters[cell];
}
