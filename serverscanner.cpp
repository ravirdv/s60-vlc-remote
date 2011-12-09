#include "serverscanner.h"



serverScanner::serverScanner(){}
void serverScanner::getData(QString ip)
{
        emit data(QVariant(ip));
}
