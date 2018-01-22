import QtQuick 2.6
import QtQuick.Controls 2.1

import yaqs.controls 1.0

Page {

    // Creation of a c++ class
    Controls{
        id: controls

    }

    Timer{
        id: controlsTimerA
        interval: 100
        repeat: true
        running: controls.accelerate

        onTriggered: proxy.throttlePos = Math.min(proxy.throttlePos+ 5, slider.to)
    }

    Timer{
        id: controlsTimerB
        interval: 100
        repeat: true
        running: controls.brake

        onTriggered: proxy.throttlePos = Math.max(proxy.throttlePos- 5, slider.from)
    }

    Timer{
        id: controlsTimerL
        interval: 100
        repeat: true
        running: controls.left

        onTriggered: proxy.wheelPos = Math.max(proxy.wheelPos - 5, -140)
    }

    Timer{
        id: controlsTimerR
        interval: 100
        repeat: true
        running: controls.right

        onTriggered: proxy.wheelPos = Math.min(proxy.wheelPos+ 5, 140)
    }


    Flow{
        anchors.fill:parent
        Slider{
            id: slider
            from:0
            to:100
            orientation: Qt.Vertical
            //onPositionChanged: proxy.throttlePos = position * 100.
            value: proxy.throttlePos
            snapMode: Slider.SnapAlways
        }
        Dial{
            from:-140
            to: 140
            width:wheelimg.width
            height:wheelimg.height
            onValueChanged:proxy.wheelPos = angle
            value: proxy.wheelPos
            Image{
                id:wheelimg
                anchors.centerIn: parent
                source:"qrc:/img/wheel.png"
                rotation:parent.angle
            }
        }
    }

    Binding{
        target: proxy
        property: "throttlePos"
        value: slider.valueAt(slider.position)
    }

}
