#ifndef YAQSPROXY_H
#define YAQSPROXY_H

#include <QObject>

class YAQSProxy : public QObject
{
    Q_OBJECT
public:
    explicit YAQSProxy(QObject *parent = 0);

signals:

public slots:
};

#endif // YAQSPROXY_H