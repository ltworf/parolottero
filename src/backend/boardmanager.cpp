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
#include "languagemanager.h"


BoardManager::BoardManager(QObject *parent) : QObject(parent)
{ }

void BoardManager::init() {
    if (this->language != nullptr) {
        delete this->language;
        this->language = nullptr;
    }

    this->multipliers.clear();
    this->letters.clear();
    this->words.clear();

    if (this->total > 0) {
        this->total = 0;
        emit total_changed(0);
    }

    if (this->_language_index < 0) {
        emit playable_changed(false);
        return;
    }
    LanguageManager lang_magr;
    this->language = lang_magr.get_language(this->_language_index, this);

    //init board
    //Give vowels double chances to appear
    QStringList morevowels = language->letters + language->vowels;
    int lcount = morevowels.size();
    for (int i = 0; i < 16; i++) {
        this->letters.append(morevowels[rand_r(&(this->_seed)) % lcount]);
        unsigned int multiplier;
        switch (rand_r(&(this->_seed)) % 10) {
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

    emit playable_changed(true);

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
    if (this->language == nullptr)
        return 0;
    QString word;

    unsigned int score = 0;
    for (int i = 0; i < cells.size(); i++) {
        word += this->letters[i];
        score += this->language->get_score(this->letters[i]) * this->multipliers[i];
    }
    if (this->language->is_word(word)) {
        this->total += score;
        this->words.append(word);
        emit total_changed(this->total);
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

void BoardManager::set_seed(unsigned int seed) {
    if (seed == this->_seed)
        return;
    this->_seed = seed;
    this->init();
    emit seed_changed(seed);
}

unsigned int BoardManager::get_seed() {
    return this->_seed;
}

void BoardManager::set_language(int language_index) {
    if (language_index == this->_language_index)
        return;
    this->_language_index = language_index;
    this->init();
    emit language_changed(language_index);
}

int BoardManager::get_language() {
    return this->_language_index;
}

bool BoardManager::get_playable() {
    return this->language != nullptr;
}

unsigned int BoardManager::get_size() {
    return 16;
}
