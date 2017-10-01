#include <QGuiApplication>
#include <QQmlApplicationEngine>
#include <QQmlContext>
#include <yaqsproxy.h>
#include <yaqscontrols.h>

int main(int argc, char *argv[])
{
    QGuiApplication app(argc, argv);

    YAQSProxy proxy;
    QQmlApplicationEngine engine;
    //qmlRegisterUncreatableType<YAQSProxy>("YAQSProxyEnum", 1, 0, "YAQSProxy", "only used for module type enums");
    engine.rootContext()->setContextProperty("proxy", &proxy);
    qmlRegisterType<YAQSControls>("yaqs.controls",1,0,"Controls");
    engine.load( QUrl("qrc:main.qml"));

    return app.exec();
}
