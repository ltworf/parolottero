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

#ifndef SCOREBOARD_H
#define SCOREBOARD_H

#include <QObject>
#include <QList>
#include <QString>

#include "scoreboarditem.h"

class Scoreboard : public QObject
{
    Q_OBJECT

    Q_PROPERTY(
            unsigned int size
            READ get_size
            NOTIFY size_changed
    )

public:
    explicit Scoreboard(QObject *parent = nullptr);
public slots:
    void clear();
    void addWord(QString word, unsigned int points);
    unsigned int get_size();
    QString get_word(unsigned int);
    unsigned int get_points(unsigned int);

signals:
    void size_changed(unsigned int);

private:
    QList<ScoreboardItem*> items;


};

#endif // SCOREBOARD_H
