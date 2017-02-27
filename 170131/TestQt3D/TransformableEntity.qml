import QtQuick 2.0
import Qt3D.Core 2.0

Entity{
    id:root
    property real scale: 1.0
    property vector3d position : Qt.vector3d(0,0,0)
    property int rotationAngle : 0
    property vector3d rotationAxis : Qt.vector3d(1, 0, 0)


    Transform {
        id: transform
        matrix: {
            var m = Qt.matrix4x4();
            m.scale(root.scale);
            m.rotate(root.rotationAngle, root.rotationAxis);
            m.translate(root.position);
            return m;
        }
    }

    components: [ transform ]
}
