import QtQuick 2.0
import Qt3D.Core 2.0
import Qt3D.Render 2.0
import Qt3D.Input 2.0
import Qt3D.Extras 2.0
import QtQuick.Scene3D 2.0
import Qt3D.Core 2.0


TransformableEntity{
    id:root
    //property real scale: 1.0
    //property vector3d position : Qt.vector3d(0,0,0)

    Arrow{
        color:"red"
        rotationAngle: -90
        rotationAxis: Qt.vector3d(0,0,1)
        scale:parent.scale
    }
    Arrow{
        color:"green"
        rotationAngle: 0
        rotationAxis : Qt.vector3d(0, 0, 0)
        scale:parent.scale
    }
    Arrow{
        color:"blue"
        rotationAxis:Qt.vector3d(1,0,0)
        rotationAngle: 90
        scale:parent.scale
    }
/*
    Transform {
        id: transform
        translation: root.position
    }

    components: [ transform ]
    */
}
