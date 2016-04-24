/*
  by sanekyy

    Страничка поста. При завершении создания странички запускается post()
    и подгружаются данные о посте с сервера.

    Доступна панель навигации для перехода к другим страницам приложения


    Содержит Column из элементов:
        photoModel - модель с фотографиями данного поста

        ScrollView->Column состоящей из:
            photoList - фотографии поста
            userId - id пользователя создавшего пост
            username - ник пользователя
            fullname - полное имя пользователя
            desctiption - описание поста
            dateEnd - дата окончания голосования
            tags - теги
            comments - комментарии ( +,- )
            Кнопка Posting


*/


import QtQuick 2.2
import QuickAndroid 0.1
import QuickAndroid.Styles 0.1
import QtQuick.Controls 1.4 as Control
import "../items"

Page {
    id: postPage
    objectName: "PostPage"

    property int postId

    function post() {
        // Создаём json для запроса к серверу
        var jsonReq = JSON.stringify({postId: postId});

        // Создаём http объект, открываем и настраиваем запрос, отправляем json
        var request = new XMLHttpRequest();
        request.open("POST", "http://" + A.serverIp + ":" + A.serverPort + "/post");;
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
                            fullName.text+=jsonRes.fullName;
                            url.text+=jsonRes.url;
                            likes.text+=jsonRes.likes;
                            desctiption.text+=jsonRes.desctiption;
                            dateEnd.text+=jsonRes.dateEnd;
                            tags.text+=jsonRes.tags;
                            comments.text+=jsonRes.comments;
                            scrollView.visible=true;
                            return;
                        }
                        // Обработка ошибки, сообщение пользователю...
                        A.openDialog("Post", jsonRes.err.description, "OK");
                        return
                    }
                }
                // Если запрос выполнен, но сервер не ответил кодом 200 ( 200 - успешное выполнение )
                A.openDialog("Error", "Server don't answer", "OK");
                console.log('Server error');
            }
        };
    }



    actionBar: ActionBar {
        id: actionBar
        upEnabled: true
        title: qsTr("Post")
        showTitle: true
        iconSource: A.pageStack.count>2? A.drawable("ic_arrow_back",Constants.black87):A.drawable("ic_menu",Constants.black87)
        onActionButtonClicked:{A.pageStack.count>2? back():A.startPage.openNavigationDrawer();}
        z: 10
    }


    Control.ScrollView{
        id: scrollView
        visible:false
        height:parent.height
        anchors.top: parent.top
        width:parent.width

        Column{
            //spacing: 8 * A.dp
            anchors.centerIn: parent
            width:postPage.width

            //space
            Item{
                width:30*A.dp
                height: actionBar.height
            }
            PhotoList{
                id:photoList
                height: 200*A.dp
                width:parent.parent.width
                //anchors.top:parent.parent.top
                //anchors.topMargin: 20*A.dp
            }
            Text {
                id:userId
                anchors.horizontalCenter: parent.horizontalCenter
                text:"userId: "
            }
            Text {
                id:username
                anchors.horizontalCenter: parent.horizontalCenter
                text:"username: "
            }
            Text {
                id:fullName
                anchors.horizontalCenter: parent.horizontalCenter
                text:"fullName: "
            }
            Text {
                id:url
                anchors.horizontalCenter: parent.horizontalCenter
                text:"url: "
            }
            Text {
                id:likes
                anchors.horizontalCenter: parent.horizontalCenter
                text:"likes: "
            }
            Text {
                id:desctiption
                anchors.horizontalCenter: parent.horizontalCenter
                text:"desctiption: "
            }
            Text {
                id:dateEnd
                anchors.horizontalCenter: parent.horizontalCenter
                text: "dataEnd: "
            }
            Text {
                id:tags
                anchors.horizontalCenter: parent.horizontalCenter
                text: "tags: "
            }
            Text{
                id:comments
                text:"comments: "
                anchors.horizontalCenter: parent.horizontalCenter
            }
        }
    }

    ListModel{
        id:photoModel
        ListElement{
            sourceImg:""
        }
    }



    Component.onCompleted: {
        post();
    }



}
