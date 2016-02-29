#include "cameracontroler.h"
#include <QQuickItemGrabResult>

CameraControler::CameraControler(QObject *parent) : QObject(), m_zxing(QZXing::DecoderFormat_QR_CODE)
{
    Q_UNUSED(parent);
    connect(&m_zxing, SIGNAL(	decodingStarted() ), this,SIGNAL(decodingStarted()));
    connect(&m_zxing, SIGNAL(	decodingFinished(bool) ), this,SIGNAL(decodingFinished(bool)));
    connect(&m_zxing, SIGNAL(	tagFound(QString) ), this,SIGNAL(tagFound(QString)));
    connect(&m_zxing, SIGNAL(	error(QString) ), this,SIGNAL(errorMessage(QString)));
}


void CameraControler::decodeQMLImage(QObject *imageObj )
{
    QQuickItemGrabResult *item = 0;
    item = qobject_cast<QQuickItemGrabResult*>(imageObj);

    QImage item_image(item->image());
    if (item_image.isNull())
        qDebug() << "invalid QML Image";
    else
        m_zxing.decodeImage(item_image);//, item_image.width(), item_image.height());

}



