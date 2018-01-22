#ifndef YAQSCONTROLS_H
#define YAQSCONTROLS_H

#include <QObject>

class YAQSControls : public QObject
{
    Q_OBJECT

    Q_PROPERTY(bool accelerate READ getAccelerate NOTIFY accelerateChanged)
    Q_PROPERTY(bool brake READ getBrake NOTIFY brakeChanged)
    Q_PROPERTY(bool left READ getLeft  NOTIFY leftChanged)
    Q_PROPERTY(bool right READ getRight  NOTIFY rightChanged)


public:
    explicit YAQSControls(QObject *parent = 0);

    inline bool getAccelerate() const
    {
        return m_accelerate;
    }

    inline void setAccelerate(const bool a)
    {
        if(m_accelerate == a)
            return;

        m_accelerate=a;
        emit accelerateChanged();
    }

    bool getLeft() const
    {
        return m_left;
    }

    inline void setLeft(const bool a)
    {
        if(m_left == a)
            return;

        m_left=a;
        emit leftChanged();
    }

    bool getRight() const
    {
        return m_right;
    }

    inline void setRight(const bool a)
    {
        if(m_right == a)
            return;

        m_right=a;
        emit rightChanged();
    }

    bool getBrake() const
    {
        return m_brake;
    }

    inline void setBrake(const bool a)
    {
        if(m_brake == a)
            return;

        m_brake=a;
        emit brakeChanged();
    }

protected:
    // Function to treat our events
    bool eventFilter(QObject *obj, QEvent *event);

    bool m_accelerate = false;
    bool m_left = false;
    bool m_right = false;
    bool m_brake = false;

signals:

    void accelerateChanged();
    void brakeChanged();
    void leftChanged();
    void rightChanged();

public slots:
};

#endif // YAQSCONTROLS_H
