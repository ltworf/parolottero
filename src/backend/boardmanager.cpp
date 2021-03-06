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

#include <QRandomGenerator>

#include "boardmanager.h"

BoardManager::BoardManager(QObject *parent) : QObject(parent)
{ }

void BoardManager::init() {
    if (this->language != nullptr) {
        this->language = nullptr;
    }
    this->scoreboard.clear();
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
    this->language = this->lang_magr.get_language(this->_language_index);

    //init board
    QRandomGenerator* rand;
    if (this->use_seed) {
        QRandomGenerator rng(this->_seed);
        rand = &rng;
    } else {
        rand = QRandomGenerator::system();
    }

    int seedcount = 0;
    QList<QChar> accumulator;
    QStringList words = this->language->get_long_words();
    while (seedcount < 10) {
        int index = rand->bounded(words.length());
        QString w = words[index];
        seedcount ++;
        for (int i = 0; i < w.length(); i++)
            accumulator.append(w[i]);
    }

    for (unsigned int i = 0; i < this->get_size(); i++) {
        int r = rand->bounded(accumulator.length());
        this->letters.append(accumulator[r]);
        accumulator.removeAt(r);

        unsigned int multiplier;
        switch (rand->bounded(10)) {
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
 *
 * It also updates the total score.
 */
unsigned int BoardManager::input_word(QList<unsigned int> cells) {
    if (this->language == nullptr)
        return 0;
    QString word;

    unsigned int score = 0;
    for (int i = 0; i < cells.size(); i++) {
        word += this->letters[cells[i]];
        score += this->language->get_score(this->letters[cells[i]]) * this->multipliers[cells[i]];
    }
    if (words.contains(word)) {
        return 0;
    }

    this->words.insert(word);

    if (this->language->is_word(word)) {
        this->total += score;
        emit total_changed(this->total);
    } else
        score = 0;

    this->scoreboard.addWord(word, score);

    return score;
}

/**
 * The current scored points for this board
 *
 * @brief BoardManager::get_total
 * @return
 */
unsigned int BoardManager::get_total() {
    return this->total;
}

/**
 * Gets the score multiplier at the specified position
 *
 * The position must be < get_size()
 *
 * @brief BoardManager::get_multiplier
 * @param cell
 * @return
 */
unsigned int BoardManager::get_multiplier(unsigned int cell) {
    return this->multipliers[cell];
}

/**
 * Gets the letter at the specified position.
 *
 * The position must be < get_size()
 *
 * @brief BoardManager::get_letter
 * @param cell
 * @return
 */
QString BoardManager::get_letter(unsigned int cell) {
    return this->letters[cell];
}

/**
 * Set a random seed.
 *
 * It is used to generate the board.
 *
 * @brief BoardManager::set_seed
 * @param seed
 */
void BoardManager::set_seed(unsigned int seed) {
    if (seed == this->_seed)
        return;
    this->_seed = seed;
    this->init();
    emit seed_changed(seed);
}

/**
 * @brief BoardManager::get_seed
 * @return the random seed in use
 */
unsigned int BoardManager::get_seed() {
    return this->_seed;
}

/**
 * Set the language index.
 *
 * -1 to not have a language.
 *
 * This makes the board not playable.
 *
 * Any other value will load the language data and
 * initialize the cells.
 *
 * @brief BoardManager::set_language
 * @param language_index
 */
void BoardManager::set_language(int language_index) {
    if (language_index == this->_language_index)
        return;
    this->_language_index = language_index;
    this->init();
    emit language_changed(language_index);
}

/**
 * @brief BoardManager::get_language
 * @return the index of the currently set language
 *
 * -1 if no language is set
 */
int BoardManager::get_language() {
    return this->_language_index;
}

/**
 * @brief BoardManager::get_playable
 * @return true if a language is set
 */
bool BoardManager::get_playable() {
    return this->language != nullptr;
}

/**
 * @brief BoardManager::get_size
 * @return number of cells on the board
 */
unsigned int BoardManager::get_size() {
    return this->rows * this->columns;
}

bool BoardManager::are_adjacent(unsigned int a, unsigned int b) {
    int col_a = a % this->columns;
    int row_a = a / this->rows;

    int col_b = b % this->columns;
    int row_b = b / this->rows;

    return std::abs(col_a - col_b) < 2 && \
           std::abs(row_a - row_b) < 2;
}

Scoreboard* BoardManager::get_scoreboard() {
    return &this->scoreboard;
}

void BoardManager::set_use_seed(bool a) {
    if (a == this->use_seed)
        return;
    this->use_seed = a;
    emit use_seed_changed(a);
}

/**
 * this defines if the seed property is used or ignored
 *
 * @brief BoardManager::get_use_seed
 * @return
 */
bool BoardManager::get_use_seed() {
    return this->use_seed;
}
