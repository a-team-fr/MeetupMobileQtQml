import QtQuick 2.0
import QtMultimedia 5.5

Item {
    id:root
    property color backgroundColor : "darkblue"
    signal takePhoto()
    property int flashMode : Camera.FlashAuto


    Rectangle{
        id:background
        anchors.fill: parent
        color : parent.backgroundColor
        opacity : 0.4; radius:5
    }
    Row{
        //anchors.centerIn: background
        Image{
            source:"qrc:/cam_photo.png"
            MouseArea{
                anchors.fill: parent
                onClicked: root.takePhoto();
            }
        }
        Image{
            id:flashMode
            source: root.flashMode === Camera.FlashAuto ? "qrc:/camera_flash_auto.png" : "qrc:/camera_flash_off.png"
            MouseArea{
                anchors.fill: parent
                onClicked: {
                    if (root.flashMode === Camera.FlashAuto) root.flashMode = Camera.FlashOff;
                    else root.flashMode = Camera.FlashAuto;
                }
            }
        }

    }
}
