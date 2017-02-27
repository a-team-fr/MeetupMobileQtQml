#include <QGuiApplication>
#include <QQmlApplicationEngine>
#include <QQmlContext>
#include "qgame.h"

int main(int argc, char *argv[])
{
    QCoreApplication::setAttribute(Qt::AA_EnableHighDpiScaling);
    QGuiApplication app(argc, argv);

    QQmlApplicationEngine engine;
    QGame game;
    engine.rootContext()->setContextProperty("game",&game);
    engine.load(QUrl(QLatin1String("qrc:/main.qml")));

    return app.exec();
}
