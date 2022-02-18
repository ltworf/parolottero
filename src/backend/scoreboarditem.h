#ifndef SCOREBOARDITEM_H
#define SCOREBOARDITEM_H

#include <QObject>

class ScoreboardItem : public QObject
{
    Q_OBJECT
public:
    explicit ScoreboardItem(QObject *parent = nullptr);

signals:

};

#endif // SCOREBOARDITEM_H
