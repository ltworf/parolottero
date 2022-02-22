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

#include "languagemanager.h"
#include <QDir>
#include <QFile>
#include <QStandardPaths>

#include <QDebug>

QStringList LanguageManager::languages() {
  return this->languagenames;
}

Language* LanguageManager::get_language(unsigned int id, QObject* parent) {
    auto langname = this->languages()[id];
    QFile ldef(this->languagefilenames.at(id));
    QFile wlist(this->languagefilenames.at(id) + ".wordlist");
    Language* l = new Language(ldef, wlist, parent);
    return l;
}

LanguageManager::LanguageManager(QObject *parent) : QObject(parent) {
    //FIXME find also in the user home
    auto dir = QDir("/usr/share/games/parolottero/language_data/");

    dir.setFilter(QDir::Files);
    dir.setSorting(QDir::Name | QDir::IgnoreCase);
    QFileInfoList list = dir.entryInfoList();
    for (int i = 0 ; i < list.size(); i++) {
        QFileInfo fileinfo = list.at(i);
        if (fileinfo.fileName().endsWith(".wordlist"))
            continue;
        this->languagefilenames.append(fileinfo.absoluteFilePath());

        QFile ldef(fileinfo.absoluteFilePath());
        ldef.open(QIODevice::ReadOnly);
        this->languagenames.append(QString(ldef.readLine(120)).trimmed());
        ldef.close();
    }

}
