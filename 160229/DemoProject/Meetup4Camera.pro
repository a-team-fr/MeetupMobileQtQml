TEMPLATE = app

QT += qml quick multimedia
CONFIG += c++11

SOURCES += main.cpp \
    cameracontroler.cpp

RESOURCES += qml.qrc
macx {
    QMAKE_MAC_SDK = macosx10.12
}


include(QZXing/QZXing.pri)

# Additional import path used to resolve QML modules in Qt Creator's code model
QML_IMPORT_PATH =

# Default rules for deployment.
include(deployment.pri)


HEADERS += \
    cameracontroler.h

DISTFILES += \
    QZXing/QZXing.pri
