import QtQuick 2.3
import QtQuick.Window 2.2
import QtMultimedia 5.5
import Qt.labs.settings 1.0

Window {
    id:mainWnd
    visible: true
    width:viewfinder.width
    height:viewfinder.height

    Settings{
        //This is to retrieve the last window position and size for the next startup
        property alias x : mainWnd.x
        property alias y : mainWnd.y
        property alias width : mainWnd.width
        property alias height : mainWnd.height
    }


    Timer{
        interval:1000
        triggeredOnStart: false
        onTriggered: viewfinder.grabToImage(function (result) {
            controler.decodeQMLImage(result);
        });
        running:true//overlay.decodeImage
        repeat:true
    }

    Connections{
        target: controler
        onDecodingStarted: console.debug("start qrdecode")
        onTagFound: {
            console.debug("done qrdecode : good")
            qrCodeFound.text = idScanned;
            qrCodeFound.color = "green";
        }

        onErrorMessage:{
            console.debug("done qrdecode : error")
            qrCodeFound.text = message;
            qrCodeFound.color = "red";
        }

        onDecodingFinished: console.debug("done qrdecode")
    }

    Camera{
        //our Camera to play with
        id:camera
        flash.mode: overlay.flashMode

        imageCapture {
            onImageCaptured: {
                previewImage.source = preview;
                previewImage.visible = true;
            }
            onImageSaved: console.log("picture saved to :"+path)
        }

        captureMode: Camera.CaptureStillImage//Camera.CaptureStillImage

        focus{
            focusMode: Camera.FocusMacro //+ Camera.FocusContinuous
            focusPointMode: Camera.FocusPointCenter
            //focusZones:
        }
        exposure{
            exposureMode: Camera.ExposureAuto
        }
    }
    VideoOutput{
        //our viewfinder to show what the Camera sees
        id:viewfinder
        source:camera
        visible: !previewImage.visible

        PinchArea{
            anchors.fill: parent
            enabled: true
            pinch.minimumScale: 1
            pinch.maximumScale: camera.maximumDigitalZoom
            scale: camera.digitalZoom
            onPinchStarted: {
                scale = camera.digitalZoom;
                zoom.visible = true;
            }
            onPinchFinished: zoom.visible = false;
            onPinchUpdated: {
                camera.digitalZoom = pinch.scale;

            }
        }
    }

    Item{
        id:zoom
        width: parent.width
        height: overlay.height
        anchors{
            bottom : parent.bottom
            left : parent.left
            right : overlay.left
        }
        ProgressBar{
            id:zoomIndicator
            visible: camera.maximumOpticalZoom * camera.maximumDigitalZoom >1
            anchors.fill: parent
            value : camera.opticalZoom * camera.digitalZoom > 0 ? camera.opticalZoom * camera.digitalZoom : ""
            minValue: 1
            maxValue: camera.maximumOpticalZoom * camera.maximumDigitalZoom
        }
        Text{
            anchors.fill: parent
            text:"zoom is not available"
            visible:!zoomIndicator.visible
            color:"white"
            minimumPixelSize: 8
            font.pixelSize: 32
            fontSizeMode : Text.Fit
        }
    }

    Overlay{
        id:overlay
        //our control panel as custom type
        anchors.bottom: parent.bottom
        anchors.horizontalCenter: parent.horizontalCenter
        width : 100; height:50
        onTakePhoto: camera.imageCapture.capture();
        onFlashModeChanged: console.log("FlashMode:"+flashMode)
    }

    Image{
        id:previewImage
        anchors.fill: parent
        fillMode: Image.PreserveAspectFit
        visible: false
        MouseArea{
            anchors.fill: parent; onClicked:parent.visible = false
        }
    }

    Text{
        id:qrCodeFound
        anchors.centerIn: parent
        width:200; height:50
        text:"Not found"
        color:"white"

   }


}
