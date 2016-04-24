/*
  by sanekyy


    Лента, здесь отображаются посты пользователей, при клике на пост, он откроется в новом окне ( Post.qml ).
    Доступна панель навигации для перехода к другим страницам приложения
    и FloatingActionButton для создания нового поста.

    По завершению создания странички, вызывается lenta() в которой подгружаются посты в ленту.


    Содержит
        Список ( list ) постов
        Модель постов
        FloatingActionButton - кнопка создания нового поста.


*/


import QtQuick 2.2
import QuickAndroid 0.1
import QuickAndroid.Styles 0.1
import QtQuick.Controls 1.4 as Control
import "../items"
import '../js/URLQuery.js' as URLQuery
import '../js/XHR.js' as XHR

Page {
    id: lentaPage
    objectName: "LentaPage"

    property string img

    property int countReq:1;


    function lenta(animObj) {

        if(animObj!==undefined) animObj.running=true;

        // Создаём json для запроса к серверу
        var jsonReq = JSON.stringify({countReq: countReq});

        // Создаём http объект, открываем и настраиваем запрос, отправляем json
        var request = new XMLHttpRequest();
        request.open("POST", "http://" + A.serverIp + ":" + A.serverPort + "/lenta");;
        request.setRequestHeader('Content-Type', 'application/json');
        request.setRequestHeader('Content-Length', jsonReq.length);
        request.send(jsonReq);
        console.log("send: ", countReq);

        request.onreadystatechange = function() {
            if (request.readyState == request.DONE) { // Выполнено?
                if(request.status && request.status === 200){ // Успешкое выполнение?
                    if(request.getResponseHeader('Content-Type')==='application/json; charset=utf-8'){
                        var jsonRes = JSON.parse(request.responseText);
                        if (!jsonRes.err){
                            if(countReq===1) model.clear();
                            // Добавляем в модель полученные посты
                            for(var j=0; j<20; j++){
                                var i=0;
                                model.append({postId:jsonRes.posts[i].postId, userId:jsonRes.posts[i].userId,
                                                 username:jsonRes.posts[i].username,
                                                 fullName:jsonRes.posts[i].fullName,
                                                 dateEnd:jsonRes.posts[i].dateEnd,
                                                 description:jsonRes.posts[i].description,
                                                 url:jsonRes.posts[i].url, tags:jsonRes.posts[i].tags,
                                                 likes:jsonRes.posts[i].likes});
                            }
                            // Останавливаем анимацию загрузки
                            if(animObj!==undefined){
                                animObj.running=false;
                                animObj.parent.rotation=0;
                            }
                            return;
                        }
                        // Обработка ошибки, сообщение пользователю...
                        console.log(jsonRes.err.description);
                        if(animObj!==undefined){
                            animObj.running=false;
                            animObj.parent.rotation=0;
                        }
                        A.openDialog("Lenta", jsonRes.err.description, "OK");
                        return;
                    }
                }
                // Если запрос выполнен, но сервер не ответил кодом 200 ( 200 - успешное выполнение )
                console.log('Server error');
                A.openDialog("Lenta", "Server error", "OK");
                if(animObj!==undefined){
                    animObj.running=false;
                    animObj.parent.rotation=0;
                }

                return;
            }
        };
    }




    actionBar: ActionBar {
        id: actionBar
        upEnabled: true
        title: qsTr("Lenta")
        showTitle: true
        iconSource: A.pageStack.count>2? A.drawable("ic_arrow_back",Constants.black87):A.drawable("ic_menu",Constants.black87)
        onActionButtonClicked:{A.pageStack.count>2? back():A.startPage.openNavigationDrawer();}
        z: 10
    }

    Control.ScrollView{
        id: scrollView
        anchors.fill: parent
        ListView{
            id: listView
            width:parent.width
            anchors.topMargin: 20*A.dp
            anchors.centerIn: parent
            spacing: 16 * A.dp
            model: model
            delegate: LentaPost{}
        }
    }

    ListModel{
        id:model
        ListElement{
            postId:0
            userId:0
            username:''
            fullName:''
            dateEnd:''
            description:''
            url:''
            tags:''
            likes:0
        }
    }

    FloatingActionButton {
        id:refresh
        anchors.bottom: addPosts.top
        anchors.right: parent.right
        anchors.bottomMargin: 20*A.dp
        anchors.rightMargin: 20*A.dp
        backgroundColor: "#cddc39"
        iconSource: A.drawable("ic_autorenew_black_48dp",Constants.black);
        depth: 3
        //anchors.verticalCenter: parent.verticalCenter
        size: Constants.large
        onClicked: {
            countReq=1;
            lenta(refreshAnim);
        }
        PropertyAnimation on rotation {
            id:refreshAnim
            property var parent:refresh
            running: false
            duration: 1000//indicator.animationDuration
            from: 0
            to: 360
            loops: Animation.Infinite
        }
    }

    FloatingActionButton {
        id: addPosts
        anchors.bottom: newPost.top
        anchors.right: parent.right
        anchors.bottomMargin: 20*A.dp
        anchors.rightMargin: 20*A.dp
        backgroundColor: "#cddc39"
        iconSource: A.drawable("ic_add_box_black_48dp",Constants.black);
        depth: 3
        //anchors.verticalCenter: parent.verticalCenter
        size: Constants.large
        onClicked: {
            countReq++;
            lenta(addPostsAnim);
        }
        PropertyAnimation on rotation {
            id:addPostsAnim
            property var parent:addPosts
            running: false
            duration: 1000//indicator.animationDuration
            from: 0
            to: 360
            loops: Animation.Infinite
        }
    }

    FloatingActionButton {
        id: newPost
        anchors.bottom: parent.bottom
        anchors.right: parent.right
        anchors.bottomMargin: 20*A.dp
        anchors.rightMargin: 20*A.dp
        backgroundColor: "#cddc39"
        iconSource: A.drawable("ic_add_black_48dp",Constants.black);
        depth: 3
        //anchors.verticalCenter: parent.verticalCenter
        size: Constants.large
        onClicked: {
            present(Qt.resolvedUrl("NewPost.qml"));
        }
    }

    Component.onCompleted: {
        model.clear();
        lenta();
    }


}
