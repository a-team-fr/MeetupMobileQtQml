import QtQuick 2.6
import QtQuick.Controls 2.1

Page {

    QtObject{
        id:calculator
        property real rpmEngine : proxy.throttlePos*20
        property real maxSpeed : rpmEngine /10
        Behavior on rpmEngine{
            NumberAnimation{
                duration: 1000
                easing.type:Easing.InOutQuad
            }
        }
        Behavior on maxSpeed{
            NumberAnimation{
                duration: 10000
                easing.type:Easing.OutQuart
            }
        }
        //onRpmEngineChanged: proxy.rpmEngine=rpmEngine
    }



    Binding{
        target:proxy
        property:"rpmEngine"
        value:calculator.rpmEngine
    }
    Binding{
        target:proxy
        property:"kmhSpeed"
        value:calculator.maxSpeed
    }



}
