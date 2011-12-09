#ifndef MYCLASS_H
#define MYCLASS_H

#include <QObject>
#include <QVariant>

class serverScanner : public QObject
{
    Q_OBJECT

public:
    serverScanner();

public slots:
    void getData(QString ip);

signals:
    void data(QVariant data);
};

#endif // MYCLASS_H
