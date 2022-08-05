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

#include "languagemanager.h"
#include <QDir>
#include <QFile>
#include <QStandardPaths>

#include <QDebug>

QStringList LanguageManager::languages() {
  return this->languagenames;
}

/**
 *
 * Returns a pointer to a Language object that is valid until:
 *
 * the parent LanguageManager exists AND
 * get_language is called again
 *
 * @brief LanguageManager::get_language
 * @param id
 * @return
 */
Language* LanguageManager::get_language(unsigned int id) {

    // Check if the language is loaded already and return it
    if (this->languages_loaded[id])
        return this->languages_loaded[id];

    this->unload_languages();

    auto langname = this->languages()[id];
    QFile ldef(this->languagefilenames.at(id));
    QFile wlist(this->languagefilenames.at(id) + ".wordlist");
    Language* l = new Language(ldef, wlist, this);

    // Save the pointer to the language, for eventual reuse
    this->languages_loaded[id] = l;

    return l;
}

void LanguageManager::unload_languages() {
    // Not loaded, unload all the loaded languages, if any
    for (int i = 0; i < this->languages_loaded.length(); i++)
        if (this->languages_loaded[i]) {
            delete this->languages_loaded[i];
            this->languages_loaded[i] = nullptr;
        }
}

LanguageManager::LanguageManager(QObject *parent) : QObject(parent) {
    this->rescan();
}

void LanguageManager::rescan() {
    // Clear all the lists
    this->languagefilenames.clear();
    this->languagenames.clear();
    this->unload_languages();
    this->languages_loaded.clear();

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
        this->languages_loaded.append(nullptr);
        ldef.close();
    }
}
