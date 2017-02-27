import QtQuick 2.0 as QQ
import Qt3D.Core 2.0
import Qt3D.Render 2.0
import Qt3D.Input 2.0
import Qt3D.Extras 2.0
import QtQuick.Scene3D 2.0


Entity{
    id:root
    property color color : "black"
    property real radius : game.spacing * 0.5
    property real z : game.size
    //property vector3d position : Qt.vector3d(idStick % 4 + 1, 0.5, Math.floor(idStick / 4) + 1)

    property int layer : 0
    property int idStick : 0

    QQ.PropertyAnimation on z {
        duration:1000
        to:root.layer + root.radius
    }

    PhongMaterial {
        id: mat
        ambient: Qt.darker(root.color)
        diffuse: root.color
    }

    Transform {
        id: transform
        property var vec2d:game.vec2dPositionFromStickId(root.idStick)
        translation: Qt.vector3d(vec2d.x,root.z,vec2d.y)
    }


    SphereMesh {
        id: mesh
        radius: root.radius
    }

    components: [ mesh, mat, transform ]
}
