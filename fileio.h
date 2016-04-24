#ifndef FILEIO_H
#define FILEIO_H

#include <QQuickItem>
#include <QObject>

class FileIO : public QObject {

    Q_OBJECT
public:
    FileIO();

    Q_PROPERTY(QUrl source READ getSource WRITE setSource NOTIFY sourceChanged)
    Q_PROPERTY(QString text READ getText WRITE setText NOTIFY textChanged)

    QUrl source;

    QString text;

public:

    Q_INVOKABLE void read();
    Q_INVOKABLE void write();

    QUrl getSource(){
        return source;
    }
    QString getText(){
        return text;
    }

signals:
    int textChanged(QString m_text);
    int sourceChanged(QUrl m_source);

public slots:
    void setText(QString m_text);
    void setSource(QUrl m_source);
};

#endif // FILEIO_H

