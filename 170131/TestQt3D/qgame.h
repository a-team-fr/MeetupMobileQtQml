#ifndef QGAME_H
#define QGAME_H

#include <QObject>
#include <QColor>
#include <QVector2D>
#include <math.h>


class QBallData{
public:
    enum CeilOption{ EMPTY = 0,RED,YELLOW};



    void addBall(uint idStack, CeilOption ballCol){

        uint layer = nbBallsOnStack(idStack);
        if (layer < 4)
        {
            uint* stack = getStack(idStack);
            stack[layer] = ballCol;
        }
    }
    bool isFull(uint idStack){
        return nbBallsOnStack(idStack) == 4;
    }

    uint nbBallsOnStack(uint idStack){
        uint* stack = getStack(idStack);

        for (uint i=0; i<4;i++)
        {
            if ( stack[i] == CeilOption::EMPTY)
                return i;
        }
        return 4;
    }




private:
    uint* getStack(uint idStack){
        Q_ASSERT(idStack < 16);
        return mat[idStack/4][idStack%4];
    }
    uint mat[4][4][4]{ 0 };
};

class QGame : public QObject
{
    Q_OBJECT
    Q_PROPERTY(QColor currentColor READ currentColor NOTIFY played)
    Q_PROPERTY(float size READ size NOTIFY sizeChanged())
    Q_PROPERTY(float spacing READ spacing NOTIFY sizeChanged())
public:
    explicit QGame(QObject *parent = 0);

    QColor currentColor(){ return isRed() ? Qt::red : Qt::yellow;}
    Q_INVOKABLE bool isRed(){ return m_currentPlayer == QBallData::CeilOption::RED;}
    float size(){ return m_size; }
    float spacing(){ return m_spacing;}

    Q_INVOKABLE QVector2D vec2dPositionFromStickId(int idStick)
    {
        float x = (idStick % 4 + 1) * m_spacing - m_size/2;
        //float y = layer * m_spacing + 0.5;
        float y = (floor(idStick / 4) + 1) * m_spacing - m_size/2;
        return QVector2D(x,y);
    }

    void next(){
        m_currentPlayer = isRed() ? QBallData::CeilOption::YELLOW : QBallData::CeilOption::RED;
        emit played();
    }

    Q_INVOKABLE void play(uint idStack){
        if (!balls.isFull(idStack))
            balls.addBall(idStack, m_currentPlayer);
        next();
    }

    Q_INVOKABLE bool isFull(uint idStack){
        return balls.isFull(idStack);
    }

    Q_INVOKABLE uint nbBallsOnStack(uint idStack){
        return balls.nbBallsOnStack(idStack);
    }

signals:
    void played();
    void sizeChanged();

public slots:

private:
    QBallData::CeilOption m_currentPlayer = QBallData::CeilOption::RED;

    QBallData balls;
    float m_size = 5;
    float m_spacing = m_size / 5.;


};

#endif // QGAME_H
