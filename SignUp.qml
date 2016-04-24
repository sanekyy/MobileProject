/*
  by sanekyy

    Страничка для регистрации пользователя, при нажатии на кнопку Sign Up
    вылезет диалоговое окно с описанием ошибки ( логин уже занят и т.д. )
    или окно с сообщением об успешной регистрацией и по нажатию на Contune
    возвращаемся на страницу Login

    Палень навигации недоступна.

    Содержит Column из элементов:

        поле для логина
        поле для пароля
        поле для подтверждения пароля
        поле для email
        поле для first name
        поле для second name

        кнопка Sign Up


*/




import QtQuick 2.2
import QuickAndroid 0.1
import QuickAndroid.Styles 0.1
import QtQuick.Layouts 1.1
import QtQuick.Controls 1.4 as Control

Page{
    id:signUpPage
    objectName: "SignUpPage"


    function signUp(username, password, email, firstName, secondName) {
        // Создаём json для запроса к серверу
        var jsonReq = JSON.stringify({username: username, password: password, email: email, firstName: firstName, secondName: secondName});

        //создаём http объект, открываем и настраиваем запрос, отправляем json
        var request = new XMLHttpRequest();
        request.open("POST", "http://" + A.serverIp + ":" + A.serverPort + "/signUp");
        request.setRequestHeader('Content-Type', 'application/json');
        request.setRequestHeader('Content-Length', jsonReq.length);
        request.send(jsonReq);

        // Следим за изменением состояния запроса
        request.onreadystatechange = function() {
            if (request.readyState == request.DONE) { // Запрос выполнен?
                if(request.status && request.status === 200){ // Успешкое выполнение?
                    if(request.getResponseHeader('Content-Type')==='application/json; charset=utf-8'){
                        var jsonRes = JSON.parse(request.responseText);
                        if (!jsonRes.err){ // Проверяем на отсутствие ошибки

                            // Сообщаем об успешной регистрации
                            A.openDialog("", "You're sign up!", "Contune");
                            return;
                        }
                        //обработка ошибки, сообщение пользователю...
                        A.openDialog("", jsonRes.err.description, "OK");
                        return;
                    }
                }
                // Если запрос выполнен, но сервер не ответил кодом 200 ( 200 - успешное выполнение )
                A.openDialog("Error", "Server don't answer", "OK");
                console.log('Server error');
                return;
            }
        };
    }


    Control.ScrollView {
        id: scrollView
        anchors.fill: parent

        Column{
            //spacing: 8 * A.dp
            anchors.centerIn: parent
            width:signUpPage.width
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
            TextField {
                id:confirmPassword
                floatingLabelText: "Confirm password"
                width: parent.width-40*A.dp
                echoMode: TextInput.PasswordEchoOnEdit
                anchors.horizontalCenter: parent.horizontalCenter
            }
            TextField {
                id:email
                floatingLabelText: "Email"
                width: parent.width-40*A.dp
                anchors.horizontalCenter: parent.horizontalCenter
            }
            TextField {
                id:firstName
                floatingLabelText: "First name"
                width: parent.width-40*A.dp
                anchors.horizontalCenter: parent.horizontalCenter
            }
            TextField {
                id:secondName
                floatingLabelText: "Second name"
                width: parent.width-40*A.dp
                anchors.horizontalCenter: parent.horizontalCenter
            }
            //space
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
                onClicked:{
                    signUp(username.text, password.text, email.text, firstName.text, secondName.text);
                }
            }
            //space
            Item{
                height: 8*A.dp
                anchors.horizontalCenter: parent.horizontalCenter
                width:parent.width
            }
        }
    }

    Connections{
        target: A.dialog
        onAccepted:{
            // Если в диалоге нажали на Contune, т.е. успешная регистрация -> возвращаемся к LoginPage
            if (A.pageStack.topPage.objectName==="SignUpPage"&&A.dialog.acceptButtonText==="Contune")
                back();
        }
    }
}
