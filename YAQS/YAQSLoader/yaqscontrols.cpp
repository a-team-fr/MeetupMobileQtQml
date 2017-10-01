#include "yaqscontrols.h"
#include <QGuiApplication>
#include <QKeyEvent>

YAQSControls::YAQSControls(QObject *parent) : QObject(parent)
{
    // All events of the application are sent to this object
    QGuiApplication::instance()->installEventFilter(this);
}

bool YAQSControls::eventFilter(QObject *obj, QEvent *event)
{
    QKeyEvent *keyEvent = dynamic_cast<QKeyEvent *>(event);
    if(keyEvent == nullptr){
        // standard event processing
        return QObject::eventFilter(obj, event);
    }

    bool pressed = event->type() == QEvent::KeyPress;

    switch(keyEvent->key()){
        case Qt::Key_Q:
            setAccelerate(pressed);
            break;
        case Qt::Key_A:
            setBrake(pressed);
            break;
        case Qt::Key_O:
            setLeft(pressed);
            break;
        case Qt::Key_P:
            setRight(pressed);
            break;
    }
    return true;
}
