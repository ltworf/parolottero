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

#ifndef LANGUAGEDOWNLOADER_H
#define LANGUAGEDOWNLOADER_H

#include <QObject>
#include <QNetworkAccessManager>
#include <QNetworkReply>
#include <QString>
#include <QUrl>


class LanguageDownloader : public QObject
{
    Q_OBJECT
public:
    explicit LanguageDownloader(QObject *parent = nullptr);

public:
    enum DownloadState {
        Error = -1,
        Idle,
        DownloadingWordlist,
        DownloadingLanguage,
        Done,
    };
    Q_ENUM(DownloadState)
    Q_PROPERTY(DownloadState state READ getState NOTIFY stateChanged)
signals:
    void stateChanged(DownloadState);
public slots:
    void download(QString);
    DownloadState getState();
private:
    QNetworkAccessManager nam;
    DownloadState state;
    void change_state(DownloadState);
    QUrl language;
    int hops;
private slots:
    void finished(QNetworkReply* reply);
};

#endif // LANGUAGEDOWNLOADER_H
