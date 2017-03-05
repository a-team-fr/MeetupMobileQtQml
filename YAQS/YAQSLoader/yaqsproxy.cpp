#include "yaqsproxy.h"

YAQSProxy::YAQSProxy(QObject *parent) : QObject(parent)
{
    timer.setInterval(msTimerResolution);
    timer.start();
    udpSocket.bind(portNumber, QUdpSocket::ShareAddress);
    connect(&timer, SIGNAL(timeout()), this, SLOT(broadcast()));
    connect(&udpSocket, SIGNAL(readyRead()),this, SLOT(processPendingDatagrams()));
}

void YAQSProxy::broadcast()
{
    for(ModuleType selectedModuleType : LstModuleType)
        broadcast(selectedModuleType);
}

void YAQSProxy::broadcast(ModuleType selectedModuleType)
{
    QByteArray datagram = QByteArray();
    datagram = QByteArray::number(selectedModuleType);
    datagram += '|';
    switch (selectedModuleType)
    {
    case ModuleType::IO:
        datagram.append( QByteArray::number(IO_dperc_WheelPos) );datagram += '|';
        datagram.append( QByteArray::number(IO_dperc_ThrottlePos) );datagram += '|';
        break;
    case ModuleType::SYSTEMS:
        datagram.append( QByteArray::number(SYST_kmhSpeed) );datagram += '|';
        datagram.append( QByteArray::number(SYST_rpmEngine) );datagram += '|';
        datagram.append( QByteArray::number(SYST_degmn_Latitude) );datagram += '|';
        datagram.append( QByteArray::number(SYST_degmn_Longitude) );datagram += '|';
        datagram.append( QByteArray::number(SYST_deg_Heading) );datagram += '|';
        break;
    }

    udpSocket.writeDatagram(datagram.data(), datagram.size(), QHostAddress::Broadcast, portNumber);

}

void YAQSProxy::processPendingDatagrams()
{
    while (udpSocket.hasPendingDatagrams()) {
        QByteArray datagram;
        datagram.resize(udpSocket.pendingDatagramSize());
        udpSocket.readDatagram(datagram.data(), datagram.size());
        QList<QByteArray> LstData = datagram.split('|');

        switch(LstData[0].toInt())
        {
        case ModuleType::IO:
            IO_dperc_WheelPos = LstData[1].toDouble();
            IO_dperc_ThrottlePos = LstData[2].toDouble();
            break;
        case ModuleType::SYSTEMS:
            SYST_kmhSpeed = LstData[1].toDouble();
            SYST_rpmEngine = LstData[2].toDouble();
            SYST_degmn_Latitude = LstData[3].toDouble();
            SYST_degmn_Longitude = LstData[4].toDouble();
            SYST_deg_Heading = LstData[5].toDouble();
            break;
        }

        emit dataReceived();
    }
}
