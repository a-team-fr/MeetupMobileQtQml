//import QtQuick 2.0 as QQ
import Qt3D.Core 2.0
import Qt3D.Render 2.0
import Qt3D.Input 2.0
import Qt3D.Extras 2.0
import QtQuick.Scene3D 2.0
import Qt3D.Core 2.0
import QtQuick 2.0 as QQ

Entity{
    id:root
    property color color : game.isFull(idStick) ? "lightgrey" : Qt.lighter(game.currentColor,glowing)
    property real glowing : 1
    property int idStick : 0
    signal clicked(int id);


    QQ.SequentialAnimation {
        running:true
        loops: QQ.Animation.Infinite
        QQ.NumberAnimation { target: root; property: "glowing"; to: 0.6; duration: 2000 }
        QQ.NumberAnimation { target: root; property: "glowing"; to: 1; duration: 2000 }
    }

    PhongMaterial {
        id: mat
        ambient: Qt.darker(root.color)
        diffuse: root.color
    }

    ObjectPicker{
        id:picker
        onPressed: {
            if (!game.isFull(idStick))
                root.clicked( root.idStick)
        }


    }

    CylinderMesh {
        id: cylinderMesh
        length:game.size
        radius:0.1
    }

    Transform{
        id:translate
        property var vec2d:game.vec2dPositionFromStickId(root.idStick)
        translation: Qt.vector3d(vec2d.x, cylinderMesh.length/2,vec2d.y)
    }

    components: [
        translate, cylinderMesh,  mat, picker
    ]




}
