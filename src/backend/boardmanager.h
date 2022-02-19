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

#ifndef BOARDMANAGER_H
#define BOARDMANAGER_H

#include <QObject>
#include <QList>
#include <QString>
#include <QStringList>

#include "language.h"
#include "scoreboard.h"

class BoardManager : public QObject
{
    Q_OBJECT
    Q_PROPERTY(
            int language
            READ get_language
            NOTIFY language_changed
            WRITE set_language
    )

    Q_PROPERTY(
            unsigned int seed
            READ get_seed()
            WRITE set_seed()
            NOTIFY seed_changed
    )

    Q_PROPERTY(
            unsigned int total
            READ get_total()
            NOTIFY total_changed
    )

    Q_PROPERTY(
            bool playable
            READ get_playable
            NOTIFY playable_changed
    )

    Q_PROPERTY(
            unsigned int size
            READ get_size()
    )

    Q_PROPERTY(
            Scoreboard* scoreboard
            READ get_scoreboard
            CONSTANT
    )

public:
    explicit BoardManager(QObject *parent = nullptr);

public slots:
    bool are_adjacent(unsigned int a, unsigned int b);
    unsigned int input_word(QList<unsigned int> cells);
    unsigned int get_total();
    unsigned int get_multiplier(unsigned int cell);
    QString get_letter(unsigned int cell);

    void set_seed(unsigned int);
    unsigned int get_seed();

    void set_language(int);
    int get_language();

    bool get_playable();

    unsigned int get_size();

    Scoreboard* get_scoreboard();

signals:
    void seed_changed(unsigned int);
    void language_changed(int);
    void total_changed(unsigned int);
    void playable_changed(bool);

private:
    void init();
    Language* language = nullptr;
    QList<QString> letters;
    QList<unsigned int> multipliers;
    Scoreboard scoreboard;

    QStringList words;
    unsigned int total = 0;
    unsigned int _seed = 0;
    int _language_index = -1;

    unsigned int rows = 4;
    unsigned int columns = 4;
};

#endif // BOARDMANAGER_H
