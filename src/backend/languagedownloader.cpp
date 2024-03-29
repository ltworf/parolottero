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

#include <QFile>
#include <QStandardPaths>
#include <QDebug>

#include "languagedownloader.h"

void LanguageDownloader::download(QString urlstring) {
    this->language = QUrl(urlstring);
    QUrl wordlist = QUrl(urlstring + ".wordlist");
    QNetworkRequest request(wordlist);
    request.setMaximumRedirectsAllowed(5);
    this->change_state(LanguageDownloader::DownloadState::DownloadingWordlist);
    this->nam.get(request);
}

LanguageDownloader::LanguageDownloader(QObject *parent) : QObject(parent) {
    connect(
        &this->nam,
        &QNetworkAccessManager::finished,
        this,
        &LanguageDownloader::finished
    );
    this->change_state(LanguageDownloader::DownloadState::Idle);
    this->hops = 10;
}


void LanguageDownloader::finished(QNetworkReply* reply) {
    if (reply->error() != QNetworkReply::NoError) {
        this->change_state(LanguageDownloader::DownloadState::Error);
        reply->deleteLater();
        return;
    }

    if (reply->hasRawHeader("Location") && this->hops > 0) {
        this->hops--;
        QNetworkRequest request(QUrl(reply->rawHeader("Location")));
        qDebug() << "follow redirect";
        request.setMaximumRedirectsAllowed(5);
        this->nam.get(request);
        reply->deleteLater();
        return;
    } else if (reply->hasRawHeader("Location") && this->hops == 0) {
        this->change_state(LanguageDownloader::DownloadState::Error);
        qDebug() << "Exceeded hops";
        reply->deleteLater();
        return;
    }

    QString destdir = QStandardPaths::writableLocation(QStandardPaths::AppLocalDataLocation) + "/language_data/";

    QString filename = this->language.fileName();

    if (this->state == LanguageDownloader::DownloadState::DownloadingWordlist) {
        filename += ".wordlist";
    }

    qDebug() << "finished, saving into" << filename;

    QFile dest(destdir + filename);
    dest.open(QIODevice::WriteOnly);
    auto data = reply->readAll();

    if (data.length() == 0) {
        qDebug() << "File is empty";
        this->change_state(LanguageDownloader::DownloadState::Error);
        reply->deleteLater();
        return;
    }

    dest.write(data);
    dest.close();
    reply->deleteLater();

    if (this->state == LanguageDownloader::DownloadState::DownloadingWordlist) {
        this->change_state(LanguageDownloader::DownloadState::DownloadingLanguage);
        QNetworkRequest request(this->language);
        request.setMaximumRedirectsAllowed(5);
        this->nam.get(request);
    } else if (this->state == LanguageDownloader::DownloadState::DownloadingLanguage) {
        this->change_state(LanguageDownloader::DownloadState::Done);
    } else {
        this->change_state(LanguageDownloader::DownloadState::Error);
        qDebug() << "Unexpected state reached";
    }

}

void LanguageDownloader::change_state(LanguageDownloader::DownloadState newstate) {
    this->state = newstate;
    emit this->stateChanged(newstate);
    qDebug() << "state changed" << newstate;
}

LanguageDownloader::DownloadState LanguageDownloader::getState() {
    return this->state;
}
