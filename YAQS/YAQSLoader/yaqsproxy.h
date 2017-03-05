#ifndef YAQSPROXY_H
#define YAQSPROXY_H

#include <QObject>
#include <QTimer>
#include <QUdpSocket>
#include <QVector3D>

class YAQSProxy : public QObject
{
    Q_OBJECT

    Q_PROPERTY(bool ready READ ready NOTIFY readyChanged)
    Q_ENUMS(ModuleType)

    Q_PROPERTY(double wheelPos MEMBER IO_dperc_WheelPos NOTIFY dataReceived)
    Q_PROPERTY(double throttlePos MEMBER IO_dperc_ThrottlePos NOTIFY dataReceived)
    Q_PROPERTY(double kmhSpeed MEMBER SYST_kmhSpeed NOTIFY dataReceived)
    Q_PROPERTY(double rpmEngine MEMBER SYST_rpmEngine NOTIFY dataReceived)
    Q_PROPERTY(double latitude MEMBER SYST_degmn_Latitude NOTIFY dataReceived)
    Q_PROPERTY(double longitude MEMBER SYST_degmn_Longitude NOTIFY dataReceived)
    Q_PROPERTY(double heading MEMBER SYST_deg_Heading NOTIFY dataReceived)

public:
    explicit YAQSProxy(QObject *parent = 0);

    enum ModuleType{
        SYSTEMS = 1, IO, SOUND, INSTRUMENTS, NAVIGATION, VISUAL
    };

    bool ready(){
        return !LstModuleType.isEmpty();
    }

    void setPortNumber(quint16 _portNumber){ portNumber = _portNumber;}
    Q_INVOKABLE quint16 getPortNumber(){ return portNumber;}

    Q_INVOKABLE void addModuleType( uint newType){
        LstModuleType.push_back(ModuleType(newType));
        emit readyChanged();
    }
    Q_INVOKABLE void removeModuleType( uint newType){
        LstModuleType.removeOne(ModuleType(newType));
        emit readyChanged();
    }


    void emptyModuleType(){
        LstModuleType.empty();
        emit readyChanged();
    }


signals:
    void readyChanged();
    void dataReceived();

public slots:
    void processPendingDatagrams();
    void broadcast();
    void broadcast(ModuleType selectedModuleType);

private:
    QUdpSocket udpSocket;
    QTimer timer;

    QVector<ModuleType> LstModuleType = QVector<ModuleType>();

    ModuleType moduleId = ModuleType::IO;
    quint16 portNumber = 45500;
    int msTimerResolution = 30;

    //DATA shared among modules
    double IO_dperc_WheelPos = 0.;
    double IO_dperc_ThrottlePos = 0.;
    double SYST_degmn_Latitude = 0;
    double SYST_degmn_Longitude = 0;
    double SYST_deg_Heading = 0;
    double SYST_kmhSpeed = 0.;
    double SYST_rpmEngine = 0.;



};

#endif // YAQSPROXY_H
