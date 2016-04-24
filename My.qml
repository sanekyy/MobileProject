/*
  by sanekyy

    Страничка пользователя, здесь отображаются данные о пользователе:
        Аватарка
        Данные
        Истори постов
        Подпищики
        Подписки

    Доступна панель навигации для перехода к другим страницам приложения



    По завершению создания странички, вызывается my() в которой подгружаются данные о пользователе.


    Содержит Column с фото и данными о пользователе.


*/


import QtQuick 2.2
import QuickAndroid 0.1
import QuickAndroid.Styles 0.1
import QtQuick.Controls 1.4 as Control


Page {
    id: myPage
    objectName: "MyPage"

    function my() {
        // Создаём json для запроса к серверу
        var jsonReq = JSON.stringify({userId: A.settings.userId, username: A.settings.username,
                                         password: A.settings.password
                                     });

        // Создаём http объект, открываем и настраиваем запрос, отправляем json
        var request = new XMLHttpRequest();
        request.open("POST", "http://" + A.serverIp + ":" + A.serverPort + "/my");;
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
                            userId.text+=jsonRes.userId;
                            username.text+=jsonRes.username;
                            firstName.text+=jsonRes.firstName;
                            lastName.text+=jsonRes.lastName;
                            scrollView.visible=true;
                            return;
                        }
                        // Обработка ошибки, сообщение пользователю...
                        A.openDialog("My Page", jsonRes.err.description, "OK");
                        return;
                    }
                }
                // Если запрос выполнен, но сервер не ответил кодом 200 ( 200 - успешное выполнение )
                console.log('Server error');
                A.openDialog("Error", "Server don't answer", "OK");
                return;
            }
        };
    }



    actionBar: ActionBar {
        id: actionBar
        upEnabled: true
        title: qsTr("My Page")
        showTitle: true
        iconSource: A.pageStack.count>2? A.drawable("ic_arrow_back",Constants.black87):A.drawable("ic_menu",Constants.black87)
        onActionButtonClicked:{A.pageStack.count>2? back():A.startPage.openNavigationDrawer();}
        z: 10
    }

    Control.ScrollView {
        id: scrollView
        visible: false
        anchors.fill: parent
        Column{
            //spacing: 8 * A.dp
            anchors.centerIn: parent
            width:myPage.width

            // space
            Item{
                width:30*A.dp
                height: actionBar.height
            }
            Image{
                sourceSize: Qt.size(48*A.dp, 48*A.dp);
                source: A.drawable("ic_android_black_48dp","Green");
                anchors.horizontalCenter: parent.horizontalCenter
            }
            Text {
                id:userId
                anchors.horizontalCenter: parent.horizontalCenter
                text : "userId: "
                type: Constants.smallText
                color : Constants.black87
            }
            Text {
                id:username
                anchors.horizontalCenter: parent.horizontalCenter
                text : "username: "
                type: Constants.smallText
                color : Constants.black87
            }
            Text {
                id:firstName
                anchors.horizontalCenter: parent.horizontalCenter
                text : "firstName: "
                type: Constants.smallText
                color : Constants.black87
            }
            Text {
                id:lastName
                anchors.horizontalCenter: parent.horizontalCenter
                text : "lastName: "
                type: Constants.smallText
                color : Constants.black87
            }
        }
    }

    Component.onCompleted: {
        my();
    }


}
