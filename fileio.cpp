
#include "QDebug"
#include "QTextCodec"
#include <fileio.h>
FileIO::FileIO()
{
}


void FileIO::read()
{
    if(source.isEmpty()) {
        return;
    }


    QFile file(source.toString());
    if(!file.exists()) {
        qWarning() << "Does not exits: " << source.toLocalFile();
        return;
    }
    if(file.open(QIODevice::ReadOnly)) {
        QTextStream stream(&file);
        //stream.setCodec(QTextCodec::codecForName("UTF"));
        text = stream.readAll();
        emit textChanged(text);
        //qDebug()<< text;
    }
}

void FileIO::write()
{
    if(source.isEmpty()) {
        return;
    }
    QFile file(source.toLocalFile());
    if(file.open(QIODevice::WriteOnly)) {
        QTextStream stream(&file);
        stream << text;
    }
}


void FileIO::setText(QString m_text){
    text=m_text;
}

void FileIO::setSource(QUrl m_source){
    source=m_source;
}
