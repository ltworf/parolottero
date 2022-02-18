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

#ifndef SCOREBOARDITEM_H
#define SCOREBOARDITEM_H

#include <QObject>
#include <QString>

class ScoreboardItem : public QObject
{
    Q_OBJECT

    Q_PROPERTY(
            unsigned int points
            READ get_points
            CONSTANT
    )

    Q_PROPERTY(
            QString word
            READ get_word
            CONSTANT
    )

public:
    explicit ScoreboardItem(QString word, unsigned int points, QObject *parent = nullptr);
public slots:
    unsigned int get_points();
    QString get_word();

private:
    unsigned int points;
    QString word;

};

#endif // SCOREBOARDITEM_H
