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

class BoardManager : public QObject
{
    Q_OBJECT
public:
    explicit BoardManager(Language *language, unsigned int seed, QObject *parent = nullptr);

public slots:
    unsigned int input_word(QList<unsigned int> cells);
    unsigned int get_total();
    unsigned int get_multiplier(unsigned int cell);
    QString get_letter(unsigned int cell);

signals:

private:
    Language* language;
    QList<QString> letters;
    QList<unsigned int> multipliers;

    QStringList words;
    unsigned int total;


};

#endif // BOARDMANAGER_H
