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

#include "language.h"

#include <QDebug>
#include <QStringList>

/**
 * @brief read_and_strip
 * @param file
 * @return
 *
 * Reads 1 line from the file, removes the \n at the end
 * and returns the rest as QString
 */
static QString read_and_strip(QFile &file) {
    char buf[128];
    qint64 size = file.readLine(buf, sizeof(buf));
    if (size == -1)
        return "";
    if (buf[size - 1] == '\n')
        buf[size - 1] = '\0';
    return QString(buf);
}

/**
 * @brief wordlistload
 * @param file
 * @param dest_set
 *
 * Loads the wordlist file into a QSet
 */
void wordlistload(QFile &file, QSet<QString> &dest_set) {
    if (!file.open(QIODevice::ReadOnly | QIODevice::Text)) {
        //TODO error
    }

    unsigned long long int c = 0;

    while (true) {
        QString word = read_and_strip(file);
        if (word.size() == 0)
            break;
        dest_set.insert(word);
        c++;
    }
    qDebug() << "Loaded words" << c;
    file.close();
}

void Language::load_langfile(QFile &file) {
    if (!file.open(QIODevice::ReadOnly | QIODevice::Text)) {
        //TODO error
    }

    // Read language name
    this->name = read_and_strip(file);

    while (true) {
        QString line = read_and_strip(file);
        if (line.size() == 0)
            break;

        QStringList parts = line.split(" ");
        this->letters.append(parts[0]);
        this->score[parts[0]] = parts[1].toUInt();
        if (parts[2].size())
            this->vowels.append(parts[0]);
    }

    file.close();
}

/**
 * @brief Language::Language
 * @param langfile: File with the language definition
 * @param wordlist: File with the list of words in the language
 * @param parent
 *
 * Class representing a language.
 */
Language::Language(QFile &langfile, QFile &wordlist, QObject *parent) : QObject(parent) {
    wordlistload(wordlist, this->words);
    this->load_langfile(langfile);
}

/**
 * @brief Language::is_word
 * @param word
 * @return
 *
 * Check if a word is in the language.
 *
 * It must be passed lowercase
 */
bool Language::is_word(QString word) {
    qDebug() << "Testing word" << word << this->words.contains(word);
    return this->words.contains(word);
}

/**
 * @brief Language::get_score
 * @param letter
 * @return
 *
 * Returns the score for a letter.
 *
 * -1 if the letter doesn't exist
 */
int Language::get_score(QString letter) {
    if (!this->score.contains(letter))
        return -1;
    return this->score[letter];
}
