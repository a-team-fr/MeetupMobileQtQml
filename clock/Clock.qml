import QtQuick 2.0
import QtGraphicalEffects 1.0

Item{
    id:clock
    property var curTime: new Date()
    property int sec : curTime.getSeconds()
    property int min : curTime.getMinutes()
    property int hours : curTime.getHours() + shift

    property alias city: cityLabel.text
    property real shift : 0

    width:400
    height:width

    Image{
        id:background
        anchors.fill: parent
        source:"qrc:/steel.jpeg"
        visible:false
    }
    Rectangle{
        id:mask
        visible:true
        anchors.fill: parent
        border.color:"black"
        border.width:2
        radius:parent.width*0.5
        color:"black"
        gradient: Gradient{
            GradientStop{
                position:0
                color:"lightgrey"
            }
            GradientStop{
                position:0.5
                color:"black"
            }
            GradientStop{
                position:1
                color:"lightgrey"
            }
        }

    }
    MouseArea{
        anchors.fill: parent
        onClicked:{
            if (mouseX < width/2)
                clock.hours--;
            else clock.hours++;
            animHour.restart();
        }
    }

    OpacityMask{
        maskSource:mask
        source:background
        anchors.fill: mask
        anchors.margins: 2
    }


    Rectangle{
        id:sec
        x : parent.width/2 - width/2
        y : parent.height/2 - height
        height:parent.height * 0.90 /2
        width : parent.height *0.01
        color:"red"
        radius:width/2
        transformOrigin: Item.Bottom
        rotation: clock.sec * 360 / 60
        RotationAnimation on rotation {
            loops: Animation.Infinite
            from: clock.sec * 360 / 60
            to: clock.sec * 360 / 60 + 360
            duration: 60 * 1000
        }

    }

    Rectangle{
        id:minute
        x : parent.width/2 - width/2
        y : parent.height/2 - height
        height:parent.height * 0.85 /2
        width : parent.height *0.02
        color:"blue"
        radius:width/2
        transformOrigin: Item.Bottom
        rotation: clock.min * 360 / 60
        RotationAnimation on rotation {
            loops: Animation.Infinite
            from: clock.min * 360 / 60
            to: clock.min * 360 / 60 + 360
            duration: 60*60*1000
        }

    }
    Rectangle{
        id:hour
        x : parent.width/2 - width/2
        y : parent.height/2 - height
        height:parent.height * 0.6 /2
        width : parent.height *0.03
        color:"darkblue"
        radius:width/2
        transformOrigin: Item.Bottom
        rotation: clock.hours * 360 / 12
        RotationAnimation on rotation {
            id:animHour
            loops: Animation.Infinite
            from: clock.hours * 360 / 12
            to: clock.hours * 360 / 12 + 360
            duration: 24*60*60*1000
        }

    }

    Repeater{
        id:texthours
        model:12
        delegate:Item{
            width:background.width
            height:background.height
            rotation:index*360/12

            Text{
                anchors.fill:parent
                text:index == 0 ? 12 : index
                color:"white"
                horizontalAlignment: Text.AlignHCenter
            }
        }
    }

    Text{
        id:cityLabel
        anchors.centerIn: parent
        color:"white"
    }
}
