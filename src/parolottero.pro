# parolottero
# Copyright (C) 2021-2022 Salvo "LtWorf" Tomaselli
#
# This program is free software: you can redistribute it and/or modify
# it under the terms of the GNU Affero General Public License as
# published by the Free Software Foundation, either version 3 of the
# License, or (at your option) any later version.
#
# This program is distributed in the hope that it will be useful,
# but WITHOUT ANY WARRANTY; without even the implied warranty of
# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
# GNU Affero General Public License for more details.
#
# You should have received a copy of the GNU Affero General Public License
# along with this program.  If not, see <https://www.gnu.org/licenses/>.
#
# author Salvo "LtWorf" Tomaselli <tiposchi@tiscali.it>

QT += core gui network

greaterThan(QT_MAJOR_VERSION, 4): QT += quick

CONFIG += c++11

# You can make your code fail to compile if it uses deprecated APIs.
# In order to do so, uncomment the following line.
DEFINES += QT_DISABLE_DEPRECATED_BEFORE=0x060000    # disables all the APIs deprecated before Qt 6.0.0

SOURCES += \
    backend/boardmanager.cpp \
    backend/language.cpp \
    backend/languagedownloader.cpp \
    backend/languagemanager.cpp \
    backend/scoreboard.cpp \
    backend/scoreboarditem.cpp \
    main.cpp

HEADERS += \
    backend/boardmanager.h \
    backend/language.h \
    backend/languagedownloader.h \
    backend/languagemanager.h \
    backend/scoreboard.h \
    backend/scoreboarditem.h

TRANSLATIONS += \
    parolottero_it_IT.ts
CONFIG += lrelease
CONFIG += embed_translations


isEmpty(target.path) {
    target.path = $${DESTDIR}/usr/games
    export(target.path)
}
INSTALLS += target

launcher.files = extras/parolottero.desktop
launcher.path = $${DESTDIR}/usr/share/applications/
INSTALLS += launcher

icon.files = extras/parolottero.svg
icon.path = $${DESTDIR}/usr/share/icons/hicolor/48x48/apps/
INSTALLS += icon

manpage.files = extras/parolottero.6
manpage.path = $${DESTDIR}/usr/share/man/man6/
INSTALLS += manpage

export(INSTALLS)

DISTFILES += \
    ui/GradientRect.qml \
    ui/About.qml \
    ui/LangSelector.qml \
    ui/LetterCell.qml \
    ui/PlayBoard.qml \
    ui/main.qml \
    ui/main_copy.qml \
    extras*

RESOURCES += qml.qrc
