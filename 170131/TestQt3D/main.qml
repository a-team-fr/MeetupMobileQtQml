import QtQuick 2.7
import QtQuick.Controls 2.0
import QtQuick.Layouts 1.0
import Qt3D.Core 2.0
import Qt3D.Render 2.0
import Qt3D.Input 2.0
import Qt3D.Extras 2.0
import QtQuick.Scene3D 2.0
import Qt3D.Core 2.0


ApplicationWindow {
    visible: true
    width: 640
    height: 480
    title: qsTr("TicTacToe")



    Scene3D {
        id:scene
        anchors.fill: parent
        focus: true
        aspects: ["input", "logic"]
        cameraAspectRatioMode: Scene3D.AutomaticAspectRatio

        Entity {
            id: sceneRoot

            Camera {
                id: camera
                projectionType: CameraLens.PerspectiveProjection
                fieldOfView: 45
                aspectRatio: 16/9
                nearPlane : 0.1
                farPlane : 1000.0
                position: Qt.vector3d( 0.0, 2.5, -8.0 )
                upVector: Qt.vector3d( 0.0, 1.0, 0.0 )
                viewCenter: Qt.vector3d( 0.0, 2.5, 0 )
            }



            OrbitCameraController {
                camera: camera
                zoomLimit: 3
            }
            //FirstPersonCameraController { camera: camera }

            components: [
                RenderSettings {
                    activeFrameGraph: ForwardRenderer {
                        clearColor: Qt.rgba(0, 0, 0, 0)
                        camera: camera
                    }
                },

                InputSettings {
                    eventSource: scene
                }

            ]

            SkyBox{
                camPosition: camera.position
            }

            Support{
                onClicked: {
                    ballsModel.append({"idStick":idStick, "layer":game.nbBallsOnStack(idStick), "isRed":game.isRed() })
                    game.play(idStick);
                }
            }

            ListModel{
                id:ballsModel
            }

            NodeInstantiator{
                id:ballsView
                model:ballsModel
                delegate: Ball{
                    idStick : model.idStick
                    color: model.isRed ? "#66ff0000" : "yellow"
                    layer: model.layer
                }

            }
            Gizmo{

            }




        }

    }
}
