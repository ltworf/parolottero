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


void wordlistload(QFile &wordlist, QSet<QString> &dest_set) {
    if (!wordlist.open(QIODevice::ReadOnly | QIODevice::Text)) {
        //TODO error
    }

    char buf[128];
    while (true) {
        qint64 size = wordlist.readLine(buf, sizeof(buf));
        if (size <= 0) break;
        buf[size - 1] = '\0'; // Remove final \n
        dest_set.insert(QString(buf));
    }
    wordlist.close();
}

Language::Language(QFile &langfile, QFile &wordlist, QObject *parent) : QObject(parent) {
    wordlistload(wordlist, this->words);
}

bool Language::is_word(QString word) {
    return this->words.contains(word);
}
