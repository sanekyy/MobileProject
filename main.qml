/*
  by sanekyy


  главное окно qml модуля
  Описаны:
    Loader - загрузчик страниц ( PageStack - стек страниц )
    Dialog - Диалоговое окно, доступное из всех всех фалов qml модуля ( A.dialog )
    Settings - настройки приложения, пользователя и т.д.

*/



import QtQuick 2.5
import QtQuick.Window 2.2
import QuickAndroid 0.1
import QuickAndroid.Styles 0.1
import Qt.labs.settings 1.0
import "./quickandroid/examples/quickandroidexample/theme"
import "pages"

Window {
    id: window;
    width: 480
    height: 640

    //белый цвет, окна не видно, пока объект не будет создан полностью
    color: "#FFFFFF"
    visible: false;


    Loader {
        id: loader
        anchors.fill: parent
        asynchronous: true
        opacity: 0
        focus: true;

        sourceComponent: PageStack {
            id: stack
            objectName: "PageStack";
            initialPage: Start {
                onPresented: {
                    window.visible = true;
                    loader.opacity = 1;
                }
            }
            Component.onCompleted: {
                stack.initialPage.start(); // функция расположена в /pages/Start.qml
            }
        }

        Behavior on opacity {
            NumberAnimation {
                duration: 200
                easing.type: Easing.OutQuad;
            }
        }
    }

    Dialog {
        id: dialog
        anchors.centerIn: parent
        Text {
            id: dialogText
            text:dialog.text
        }
        z: 20
    }

    Settings {
        id: settings
        category: "Settings"
        property bool loggined: false
        property string username: ""
        property string password: ""
        property int userId:0
        property string session: ""
        property string accessTokenVk: ""
    }


    Component.onCompleted: {
        ThemeManager.currentTheme = AppTheme;
    }
}
