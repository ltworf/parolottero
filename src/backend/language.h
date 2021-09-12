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

#ifndef LANGUAGE_H
#define LANGUAGE_H

#include <QObject>
#include <QString>
#include <QSet>
#include <QFile>
#include <QMap>
#include <QList>

class Language : public QObject
{
    Q_OBJECT
public:
    explicit Language(QFile &langfile, QFile &wordlist, QObject *parent = nullptr);
    QList<QString> letters;
    QList<QString> vowels;
    QString name;

public slots:
    bool is_word(QString word);
    int get_score(QString letter);

private:
    QSet<QString> words;
    QMap<QString, unsigned int> score;
    void load_langfile(QFile &file);

signals:

};

#endif // LANGUAGE_H
