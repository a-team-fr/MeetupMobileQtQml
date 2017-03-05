import QtQuick 2.5

ListModel{
    ListElement{
        qmlUrl:"qrc:/module/io.qml"
        moduleType:2
        name:"IO"
        description:"get position of wheel steering, pedals, switches..."
    }
    ListElement{
        qmlUrl:"qrc:/module/systems.qml"
        moduleType:1
        name:"Systems"
        description:"driving and engine models, computations"
    }
}
