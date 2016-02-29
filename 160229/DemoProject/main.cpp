#include <QGuiApplication>
#include <QQmlApplicationEngine>
#include <QQmlContext>
#include "cameracontroler.h"


int main(int argc, char *argv[])
{
    QGuiApplication app(argc, argv);

    QQmlApplicationEngine engine;
    CameraControler theOneAndOnlyCC;
    engine.rootContext()->setContextProperty("controler", &theOneAndOnlyCC);
    engine.load(QUrl(QStringLiteral("qrc:/main.qml")));

    return app.exec();
}
