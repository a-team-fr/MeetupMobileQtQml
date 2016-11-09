#include <QGuiApplication>
#include <QQmlApplicationEngine>

int main(int argc, char *argv[])
{
    QGuiApplication app(argc, argv);

    QQmlApplicationEngine engine;
    //engine.load(QUrl(QStringLiteral("qrc:/mainAll.qml")));
    engine.load(QUrl(QStringLiteral("qrc:/mainClockCmp.qml")));

    return app.exec();
}
