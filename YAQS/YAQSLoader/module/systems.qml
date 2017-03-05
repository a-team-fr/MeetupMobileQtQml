import QtQuick 2.6
import QtQuick.Controls 2.1
import QtPositioning 5.3

Page {

    QtObject{
        id:calculator
        property real rpmEngine : proxy.throttlePos*20
        property real maxSpeed : rpmEngine /10
        property var position : QtPositioning.coordinate(47.212047, -1.551647)
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

    Timer{
        interval:30
        repeat:true
        running:true
        onTriggered: {
            if (proxy.kmhSpeed > 0){
                proxy.heading += proxy.wheelPos / 8.;
                calculator.position = calculator.position.atDistanceAndAzimuth(proxy.kmhSpeed/120,proxy.heading)
            }
            proxy.latitude = calculator.position.latitude
            proxy.longitude = calculator.position.longitude

        }
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
