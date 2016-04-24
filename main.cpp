#include <QApplication>
#include <QQmlApplicationEngine>

#include <QQuickView>
#include <QQmlContext>
#include "quickandroid.h"
#include "qadrawableprovider.h"
#include "qasystemdispatcher.h"
#include <fileio.h>


#ifdef Q_OS_ANDROID
#include <QtAndroidExtras/QAndroidJniObject>
#include <QtAndroidExtras/QAndroidJniEnvironment>

JNIEXPORT jint JNI_OnLoad(JavaVM* vm, void*) {
    Q_UNUSED(vm);
    qDebug("NativeInterface::JNI_OnLoad()");

    // It must call this function within JNI_OnLoad to enable System Dispatcher
    QASystemDispatcher::registerNatives();

    /* Optional: Register your own service */

    // Call quickandroid.example.ExampleService.start()
    QAndroidJniObject::callStaticMethod<void>("quickandroid/example/ExampleService",
                                              "start",
                                              "()V");

    return JNI_VERSION_1_6;
}
#endif



int main(int argc, char *argv[])
{
    QApplication app(argc, argv);

    app.setOrganizationName("Some Company");
    app.setOrganizationDomain("somecompany.com");
    app.setApplicationName("Amazing Application");

    QQmlApplicationEngine engine;

    qmlRegisterType<FileIO>("org.example", 1, 0, "FileIO");

    /* QuickAndroid Initialization */
        engine.addImportPath("qrc:///"); // Add QuickAndroid into the import path
        // Setup "drawable" image provider
        QADrawableProvider* provider = new QADrawableProvider();
        provider->setBasePath("qrc:///res/res"); //"qrc:////res"
        engine.addImageProvider("drawable",provider);
        /* End of QuickAndroid Initialization */

        //engine.rootContext()->setContextProperty("MyString","QT + QML");


    engine.load(QUrl(QStringLiteral("qrc:/main.qml")));


    return app.exec();
}
