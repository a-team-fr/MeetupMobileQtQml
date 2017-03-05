import QtQuick 2.6
import QtQuick.Controls 2.1

Page {
    Flow{
        anchors.fill:parent
        Slider{
            from:0
            to:100
            value:0
            orientation: Qt.Vertical
            onPositionChanged: proxy.throttlePos = position * 100.
            snapMode: Slider.SnapAlways
        }
        Dial{
            width:wheelimg.width
            height:wheelimg.height
            onValueChanged: proxy.wheelPos = angle
            value:0.5
            Image{
                id:wheelimg
                anchors.centerIn: parent
                source:"qrc:/img/wheel.png"
                rotation:parent.angle
            }
        }
    }

}
