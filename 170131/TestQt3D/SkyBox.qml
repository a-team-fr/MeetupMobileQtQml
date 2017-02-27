//import QtQuick 2.0
import Qt3D.Core 2.0
import Qt3D.Render 2.0
import Qt3D.Input 2.0
import Qt3D.Extras 2.0
import QtQuick.Scene3D 2.0
import Qt3D.Core 2.0


Entity {
    id: root

    property int planeSize : 1000
    property vector3d camPosition : Qt.vector3d(0.,0.,0.)

    PlaneMesh {
        id: mesh
        width: root.planeSize
        height: root.planeSize
        meshResolution: Qt.size(2, 2)
    }

    Transform{
                id:offsetCam
                translation: root.camPosition
            }

    components: [
        offsetCam
    ]

    Entity{
        id:negx
        DiffuseMapMaterial {
            id: matnegx
            ambient: Qt.rgba( 1.0, 1.0, 1.0, 1.0 )
            diffuse:  "/skybox/skybox_negx.jpg"
            shininess: 0.0
            //specular:"white"
        }
        Transform{
            id:transnegx
            translation: Qt.vector3d(-root.planeSize/2,0.,0.)
            rotation : fromAxesAndAngles(Qt.vector3d(1.,0.,0.), -90.,Qt.vector3d(0.,1.,0.), -90.)

        }

        components: [
            transnegx, mesh,  matnegx
        ]
    }
    Entity{
        id:posx
        DiffuseMapMaterial {
            id: matposx
            ambient: Qt.rgba( 1.0, 1.0, 1.0, 1.0 )
            diffuse:  "/skybox/skybox_posx.jpg"
            shininess: 0.0
        }
        Transform{
            id:transposx
            translation: Qt.vector3d(root.planeSize/2,0.,0.)
            rotation : fromAxesAndAngles(Qt.vector3d(1.,0.,0.), -90.,Qt.vector3d(0.,1.,0.), 90.)
        }

        components: [
            transposx, mesh,  matposx
        ]
    }
    Entity{
        id:negz
        DiffuseMapMaterial {
            id: matnegz
            ambient: Qt.rgba( 1.0, 1.0, 1.0, 1.0 )
            diffuse:  "/skybox/skybox_negz.jpg"
            shininess: 0.0
        }
        Transform{
            id:transnegz
            translation: Qt.vector3d(0.,0.,-root.planeSize/2)
            rotation : fromAxesAndAngles(Qt.vector3d(1.,0.,0.), 90.,Qt.vector3d(0.,0.,1.), 180.)
        }

        components: [
            transnegz, mesh,  matnegz
        ]
    }
    Entity{
        id:posz
        DiffuseMapMaterial {
            id: matposz
            ambient: Qt.rgba( 1.0, 1.0, 1.0, 1.0 )
            diffuse:  "/skybox/skybox_posz.jpg"
            shininess: 0.0
        }
        Transform{
            id:transposz
            translation: Qt.vector3d(0.,0.,root.planeSize/2)
            rotation : fromAxisAndAngle(Qt.vector3d(1.,0.,0.), -90.)
        }

        components: [
            transposz, mesh,  matposz
        ]
    }

    Entity{
        id:negy
        DiffuseMapMaterial {
            id: matnegy
            ambient: Qt.rgba( 1.0, 1.0, 1.0, 1.0 )
            diffuse:  "/skybox/skybox_negy.jpg"
            shininess: 0.0
        }
        Transform{
            id:transnegy
            translation: Qt.vector3d(0.,-root.planeSize/2,0.)

        }

        components: [
            transnegy, mesh,  matnegy
        ]
    }
    Entity{
        id:posy
        DiffuseMapMaterial {
            id: matposy
            ambient: Qt.rgba( 1.0, 1.0, 1.0, 1.0 )
            diffuse:  "/skybox/skybox_posy.jpg"
            shininess: 0.0
        }
        Transform{
            id:transposy
            translation: Qt.vector3d(0.,root.planeSize/2,0.)
            rotation : fromAxisAndAngle(Qt.vector3d(1.,0.,0.), 180.)
        }

        components: [
            transposy, mesh,  matposy
        ]
    }



}
