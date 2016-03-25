import QtQuick 2.3
import QtQuick.Window 2.2
import QtMultimedia 5.5
import QtQuick.Controls 1.4
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
        //onDecodingStarted: console.debug("start qrdecode")
        onTagFound: {
            //console.debug("done qrdecode : good")
            qrCodeFound.text = idScanned;
            qrCodeFound.color = "green";
        }

        onErrorMessage:{
            //console.debug("done qrdecode : error")
            qrCodeFound.text = message;
            qrCodeFound.color = "red";
        }

        //onDecodingFinished: console.debug("done qrdecode")
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
            // Setting focusMode depending on a switch button
            focusMode: focusSwitch.checked?Camera.FocusAuto:Camera.FocusManual //Camera.FocusMacro //+ Camera.FocusContinuous

            focusPointMode: focusSwitch.checked?Camera.FocusPointCenter:Camera.FocusPointCustom //Camera.FocusPointCenter
            // customFocusPoint is only used if FocusPointCustom (screen position) is given
            customFocusPoint: focusControl.relativeposition // x,y between 0 and 1
            //focusZones:
        }
        exposure{
            exposureMode: Camera.ExposurePortrait
            // Adding exposure compesantion for the pictures (not working on my mac, only in android)
            exposureCompensation: expoSlider.value;
        }
    }

    VideoOutput{
        //our viewfinder to show what the Camera sees
        id:viewfinder
        source:camera
        visible: !previewImage.visible
        fillMode: VideoOutput.PreserveAspectFit
        autoOrientation: true

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
            minimumValue: 1
            maximumValue: camera.maximumOpticalZoom * camera.maximumDigitalZoom
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
            anchors.fill: parent;
            onClicked:parent.visible = false
        }
    }

    Text{
        id:qrCodeFound
        anchors.centerIn: parent
        width:200; height:50
        text:"Not found"
        color:"white"

   }


    // Exposure control!!
    Column{
        id: exposureControl
        anchors.left: parent.left
        anchors.verticalCenter: parent.verticalCenter
        height: expoSlider.height+expoText.height

        // Slider to select the under/over exposition value
        Slider {
            id: expoSlider
            maximumValue: 3
            minimumValue: -3
            orientation: Qt.Vertical
            stepSize: 0.5
            height: mainWnd.height/3
        }
        Text{
            id: expoText
            text:expoSlider.value.toFixed(1)
            anchors.top: expoSlider.bottom
        }
    }

    // Focus selector
    Column{
        id: focusSettings
        anchors.right: parent.right
        anchors.verticalCenter: parent.verticalCenter

        Text{
            id: focusMode
            text: focusSwitch.checked?"Focus: Auto  ":"Focus: Manual"
        }
        Switch{
            id: focusSwitch
            checked: true
        }
    }

    // Focus target
    Image{


        id: focusControl
        visible: !focusSwitch.checked // in auto mode there is no focus marker

        // Obtained from: http://www.flaticon.com/free-icon/square-target-interface-symbol_54048
        source:"qrc:/camera_square.png"
        width: 75
        height: 75

        // We create a property becaus point is required by the Focus property
        property point relativeposition
        // We convert the convert position of the image into the center, and normalize between 0 and 1
        relativeposition: Qt.point((this.x+this.width/2.0)/viewfinder.width,
                                   (this.y+this.height/2.0)/viewfinder.height)

        // Verifing the values
        onRelativepositionChanged: console.log('Focus Position'+relativeposition)

        // Initial position
        x: (viewfinder.width-this.width)/2
        y: (viewfinder.height-this.height)/2


        // Mouse area to allow the image to be dragable
        MouseArea{
                anchors.fill: parent
                drag.target: focusControl
                drag.axis: Drag.XAndYAxis
                drag.minimumX: 0
                drag.minimumY: 0
                drag.maximumX: viewfinder.width-parent.width
                drag.maximumY: viewfinder.height-parent.height
        }
    }

}
