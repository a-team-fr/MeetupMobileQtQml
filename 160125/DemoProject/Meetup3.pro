TEMPLATE = app

QT += qml quick positioning location
CONFIG += c++11

SOURCES += main.cpp

RESOURCES += qml.qrc

macx {
    QMAKE_MAC_SDK = macosx10.12
}

# Additional import path used to resolve QML modules in Qt Creator's code model
QML_IMPORT_PATH =

# Default rules for deployment.
include(deployment.pri)
