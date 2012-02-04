#include <QtGui/QApplication>
#include <QGraphicsObject>
#include "qmlapplicationviewer.h"
#include <QNetworkInterface>
#include <QAbstractSocket>
#include <QNetworkAddressEntry>
#include <QDebug>
#include <QNetworkConfiguration>
#include <QNetworkConfigurationManager>
#include <QNetworkSession>
#include "serverscanner.h"
int main(int argc, char *argv[])
{
    QApplication app(argc, argv);
    QmlApplicationViewer viewer;
    serverScanner s;
    viewer.setMainQmlFile(QLatin1String("qml/VLCRemote/main.qml"));
    viewer.showExpanded();
    QObject *rootObject = dynamic_cast<QObject*>(viewer.rootObject());
    QObject::connect(&s, SIGNAL(data(QVariant)), rootObject, SLOT(updateData(QVariant)));
    foreach(QNetworkInterface interface, QNetworkInterface::allInterfaces())
        {
            if(interface.flags().testFlag(QNetworkInterface::IsUp) &&
                    (!interface.flags().testFlag(QNetworkInterface::IsLoopBack)))
            {
                foreach(QNetworkAddressEntry entry, interface.addressEntries())
                {

                   if(entry.ip().protocol() == QAbstractSocket::IPv4Protocol)
                   {
                       qDebug()<< entry.ip().toString();
                       s.getData(entry.ip().toString());
                   }
                }
            }
        }
    return app.exec();
}

