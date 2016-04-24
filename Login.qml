/*
  by sanekyy

    Страничка для аутентификации пользователя, ввод логина и пароля
    или входа с помощью соц сетей. С неё можно перейти на страницу
    регистрации, а так же при успешной аутентификации откроется лента.

    Палень навигации недоступна.

    Содержит Column из элементов:
        поле для логина
        поле для пароля
        кнопка login
        кнопка Sign Up
        кнопка для входа через VK


*/




import QtQuick 2.2
import QuickAndroid 0.1
import QuickAndroid.Styles 0.1
import QtQuick.Layouts 1.1
import Qt.labs.settings 1.0

Page{
    id:loginPage
    objectName: "LoginPage"

    Column{
        anchors.centerIn: parent
        width:parent.width

        Item{
            height: loginPage.height>loginPage.width ? 48*A.dp : 6*A.dp
            anchors.horizontalCenter: parent.horizontalCenter
            width:parent.width
        }
        TextField {
            id:username
            floatingLabelText: "Username"
            width: parent.width-40*A.dp
            anchors.horizontalCenter: parent.horizontalCenter
        }
        TextField {
            id:password
            floatingLabelText: "Password"
            width: parent.width-40*A.dp
            echoMode: TextInput.PasswordEchoOnEdit
            anchors.horizontalCenter: parent.horizontalCenter
        }
        RaisedButton{
            text: "Login"
            height: 35*A.dp
            width: parent.width-40*A.dp
            anchors.horizontalCenter: parent.horizontalCenter
            onClicked:{
                A.startPage.login(username.text, password.text);
            }
        }
        // spacing
        Item{
            height: 8*A.dp
            anchors.horizontalCenter: parent.horizontalCenter
            width:parent.width
        }
        RaisedButton{
            text: "Sign up"
            height: 35*A.dp
            width: parent.width-40*A.dp
            anchors.horizontalCenter: parent.horizontalCenter
            onClicked: {
                present(Qt.resolvedUrl('SignUp.qml'));
            }
        }
        // spacing
        Item{
            height: 8*A.dp
            anchors.horizontalCenter: parent.horizontalCenter
            width:parent.width
        }
        Row{
            height: 48*A.dp
            anchors.horizontalCenter: parent.horizontalCenter
            Image{
                source: A.drawable("vk")
                sourceSize: Qt.size(48*A.dp,48*A.dp);
                Ink{
                    anchors.fill: parent
                    onClicked: {
                        present(Qt.resolvedUrl('./LoginVk.qml'),undefined, false);
                    }
                }
            }
        }
    }

}
