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

#include <QGuiApplication>
#include <QQmlApplicationEngine>
#include <QQmlContext>

#include <QLocale>
#include <QTranslator>
#include <QString>
#include <QSysInfo>
#include <QCryptographicHash>

#include "backend/languagemanager.h"
#include "backend/boardmanager.h"
#include "backend/languagedownloader.h"

/**
 *
 * Get the machine id and return a qstring of its hash.
 *
 * Freedesktop standard states that the machine id should not
 * be exposed directly but hashed.
 *
 * I need this to put in bugreports, to identify the sender in case of
 * abuse.
 *
 * @brief hashed_machine_id
 * @return
 */
QString hashed_machine_id() {
    auto id = QSysInfo::machineUniqueId();

    QCryptographicHash hasher(QCryptographicHash::Sha3_256);
    hasher.addData(id);
    QString r(hasher.result().toHex());
    return r;
}

int main(int argc, char *argv[])
{
#if QT_VERSION < QT_VERSION_CHECK(6, 0, 0)
    QCoreApplication::setAttribute(Qt::AA_EnableHighDpiScaling);
#endif

    QGuiApplication app(argc, argv);

    QTranslator translator;
    const QStringList uiLanguages = QLocale::system().uiLanguages();
    for (const QString &locale : uiLanguages) {
        const QString baseName = "parolottero_" + QLocale(locale).name();
        if (translator.load(":/i18n/" + baseName)) {
            app.installTranslator(&translator);
            break;
        }
    }

    app.setApplicationName("Parolottero");
    app.setOrganizationDomain("Parolottero");
    app.setOrganizationName("Parolottero");

    QQmlApplicationEngine engine;
    const QUrl url(QStringLiteral("qrc:/ui/main.qml"));
    QObject::connect(&engine, &QQmlApplicationEngine::objectCreated,
                     &app, [url](QObject *obj, const QUrl &objUrl) {
        if (!obj && url == objUrl)
            QCoreApplication::exit(-1);
    }, Qt::QueuedConnection);
    LanguageManager language_manager(&engine);
    QString version = QString(VERSION);


    engine.rootContext()->setContextProperty("languageManager", &language_manager);
    engine.rootContext()->setContextProperty("ApplicationVersion", version); // For the about string
    engine.rootContext()->setContextProperty("MachineId", hashed_machine_id()); // For identifying bugreporters
    qmlRegisterType<BoardManager>("ltworf.parolottero", 1, 0, "BoardManager");
    qmlRegisterType<LanguageDownloader>("ltworf.parolottero", 1, 0, "LanguageDownloader");

    engine.load(url);

    return app.exec();
}
