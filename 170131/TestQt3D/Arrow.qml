//import QtQuick 2.0
import Qt3D.Core 2.0
import Qt3D.Render 2.0
import Qt3D.Input 2.0
import Qt3D.Extras 2.0
import QtQuick.Scene3D 2.0
import Qt3D.Core 2.0


Entity{
    id:root
    property color color : "red"
    property int length : 1
    property int rotationAngle : 0
    property vector3d rotationAxis : Qt.vector3d(1, 0, 0)
    property vector3d position : Qt.vector3d(0, root.length*9/20, 0)
    property real scale: 1.0
    signal clicked()

    ObjectPicker{
        id:picker
        onClicked: root.clicked()

    }

    PhongMaterial {
        id: mat
        ambient: Qt.darker(root.color)
        diffuse: root.color
    }

    Transform {
        id: transform
        //scale:1
        //translation: Qt.vector3d(0, root.length/2, 0)
        //rotation: fromAxisAndAngle( root.rotationAxis, root.rotationAngle)
        matrix: {
            var m = Qt.matrix4x4();
            m.scale(root.scale);
            m.rotate(root.rotationAngle, root.rotationAxis);
            m.translate(root.position);
            return m;
        }
    }


    CylinderMesh {
        id: cylinder
        radius: root.length / 10
        length:root.length
        //rings:2
        //slices:4
    }

    Entity{
        id:coneEnt
        ConeMesh {
            id: cone
            bottomRadius: cylinder.radius*1.5
            length:cylinder.length / 2
            hasBottomEndcap: true

        }
        Transform{
            id:translate
            translation: Qt.vector3d(0,cylinder.length-cone.length/2,0)
        }

        components: [
            translate, cone,  mat,picker
        ]
    }

    components: [ coneEnt, cylinder, mat, transform ]
}
