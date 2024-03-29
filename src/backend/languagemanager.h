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

#ifndef LANGUAGEMANAGER_H
#define LANGUAGEMANAGER_H

#include <QObject>
#include <QStringList>
#include <QList>
#include "language.h"

class LanguageManager : public QObject
{
    Q_OBJECT
public:
    explicit LanguageManager(QObject *parent = nullptr);

signals:

public slots:
    QStringList languages();
    Language* get_language(unsigned int);
    void rescan();
private:
    QStringList languagenames;
    QStringList languagefilenames;
    QList<Language*> languages_loaded;
    void unload_languages();
};

#endif // LANGUAGEMANAGER_H
