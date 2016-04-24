/*
  by sanekyy

    Страничка для создания нового поста. После заполнения необходимых полей и нажатия на кнопку Posting
    вызывается newPost(), в которой вся информация о новом посте передаётся на сервер

    Доступна панель навигации для перехода к другим страницам приложения


    Содержит элементы:
        imagePicker - для выбора фотографий с телефона ( только для android )
        photoModel - модель с фотографиями выбранными пользователем
        photoBottomSheet - панель, вылазющая снизу при нажатии на кнопку добавления фото.

        ScrollView->Column состоящей из:
            photoList - фотографии поста
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
import org.example 1.0

Page {
    id: newPostPage
    objectName: "NewPostPage"


    function func(){
        console.log(photoModel.get(1).sourceImg);

        //file.source=photoModel.get(1).sourceImg;
        file.read();


        /*

            var boundary = String('Asrf456BGe4h');
            var boundaryMiddle = '--' + boundary + '\r\n';
            var boundaryLast = '--' + boundary + '--\r\n'

            var body = ['\r\n'];

            //for (var key in data) {
            // добавление поля
            body.push('Content-Disposition: form-data; name="userPhoto"; filename="1.txt"' + '"\r\n\r\n' + file.text + '\r\n');
            //}

            body = body.join(boundaryMiddle) + boundaryLast;

            var http = new XMLHttpRequest();
            http.open("POST", "http://" + A.serverIp + ":" + A.serverPort + "/image",true);

            http.setRequestHeader('Content-Type', 'multipart/form-data; boundary=' + boundary);


            console.log("SEND: ", body);
            http.send(body);

            http.onreadystatechange = function() {
                if (http.readyState == http.DONE) { // Выполнено?
                    if(http.status && http.status === 200){ // Успешкое выполнение?
                        console.log("STATUS 200");
                        console.log(http.responseText);
                    }
                }
            }*/
    }



    FileIO{
        id:file
        source: "file:%2Fmnt%2Fsdcard%2FDCIM%2F2016-02-28%2000.45.37.jpg"
        onTextChanged: {
            console.log("TEXT: ", text);
        }
    }











    function newPost(description, dateEnd, comments, tags, images) {
        // Создаём json для запроса к серверу
        var jsonReq = JSON.stringify({userId: A.settings.userId, username: A.settings.username,
                                         password: A.settings.password,
                                         desctiption: description, dateEnd: dateEnd, comments: comments,
                                         tags: tags, images: images });

        // Создаём http объект, открываем и настраиваем запрос, отправляем json
        var request = new XMLHttpRequest();
        request.open("POST", "http://" + A.serverIp + ":" + A.serverPort + "/newPost");;
        request.setRequestHeader('Content-Type', 'application/json');
        request.setRequestHeader('Content-Length', jsonReq.length);
        request.send(jsonReq);

        request.onreadystatechange = function() {
            if (request.readyState == request.DONE) { // Выполнено?
                if(request.status && request.status === 200){ // Успешкое выполнение?
                    if(request.getResponseHeader('Content-Type')==='application/json; charset=utf-8'){
                        var jsonRes = JSON.parse(request.responseText);
                        if (!jsonRes.err){
                            A.openDialog("New post", "Posting successfuly", "Contune");
                            return;
                        }
                        // Обработка ошибки, сообщение пользователю...
                        A.openDialog("New post", jsonRes.err.description, "OK");
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
        title: qsTr("New Post")
        showTitle: true
        iconSource: A.pageStack.count>2? A.drawable("ic_arrow_back",Constants.black87):A.drawable("ic_menu",Constants.black87)
        onActionButtonClicked:{ A.pageStack.count>2? back():A.startPage.openNavigationDrawer();}
        z: 10
    }

    ImagePicker {
        id: imagePicker;
        onImageUrlChanged: {
            photoModel.insert(1,{"sourceImg":imagePicker.imageUrl})
        }
    }

    Control.ScrollView{
        height:parent.height
        anchors.top: parent.top
        width:parent.width

        Column{
            //spacing: 8 * A.dp
            anchors.centerIn: parent
            width:newPostPage.width

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
            TextField {
                id:desctiption
                floatingLabelText: "Desctiption"
                width: parent.width-40*A.dp
                anchors.horizontalCenter: parent.horizontalCenter
                text:"Hi, I need help!"
            }
            TextField {
                id:dateEnd
                floatingLabelText: "Data end"
                width: parent.width-40*A.dp
                anchors.horizontalCenter: parent.horizontalCenter
            }
            TextField {
                id:tags
                floatingLabelText: "Tags"
                width: parent.width-40*A.dp
                anchors.horizontalCenter: parent.horizontalCenter
                text: "#help, #blabla"
            }
            Row{
                anchors.horizontalCenter: parent.horizontalCenter
                Text{
                    text:"Comments:"
                    anchors.verticalCenter: parent.verticalCenter
                }
                //space
                Item{
                    width:30*A.dp
                    height: 10*A.dp
                }
                MySwitch{
                    id:comments
                    //anchors.horizontalCenter: parent.horizontalCenter
                    anchors.verticalCenter: parent.verticalCenter
                    //anchors.right: parent.right
                    //anchors.rightMargin: 16*A.dp
                }
            }
            Item{
                width:30*A.dp
                height: 10*A.dp
            }
            RaisedButton{
                text: "Posting"
                height: 35*A.dp
                width: parent.width-40*A.dp
                anchors.horizontalCenter: parent.horizontalCenter
                onClicked:{
                    func();
                    //newPost(desctiption.text, dateEnd.text, comments.checked, tags.tesdt, photoModel);
                }
            }
        }
    }

    ListModel{
        id:photoModel
        ListElement{
            sourceImg:""
        }
    }

    PhotoBottomSheet{
        id : photoBottomSheet
    }


    Connections{
        target: A.dialog
        onAccepted:{
            // Если в диалоге нажали на Contune, т.е. успешное добавление -> возвращаемся к LentaPage
            if (A.pageStack.topPage.objectName==="NewPostPage"&&A.dialog.acceptButtonText==="Contune"){
                // Проверяем, есть ли LentaPage в стеке
                var isLentaInStack=false;
                for (var i=0; i<A.pageStack.count; i++){
                    if (A.pageStack.pages[i].objectName==="LentaPage"){
                        isLentaInStack=true;
                        console.log("isClicedPageInStack");
                        break;
                    }
                }

                if(isLentaInStack){
                    while(A.pageStack.count>(i+1))
                        A.pageStack.pop();
                    return;
                }

                while(A.pageStack.pages[A.pageStack.count-1].objectName!=="LentaPage"&&A.pageStack.count>1)
                    A.pageStack.pop(false);

                present(Qt.resolvedUrl("Lenta.qml"),undefined, false);
            }
        }
    }

}








/*function func(){

        var boundary = String('Asrf456BGe4h');
        var boundaryMiddle = '--' + boundary + '\r\n';
        var boundaryLast = '--' + boundary + '--\r\n'

        var body = ['\r\n'];

        //for (var key in data) {
        // добавление поля
        body.push('Content-Disposition: form-data; name="userPhoto"; filename="1.txt"' + '"\r\n\r\n' + file.text + '\r\n');
        //}

        body = body.join(boundaryMiddle) + boundaryLast;

        var http = new XMLHttpRequest();
        http.open("POST", "http://" + A.serverIp + ":" + A.serverPort + "/image",true);

        http.setRequestHeader('Content-Type', 'multipart/form-data; boundary=' + boundary);


        console.log("SEND: ", body);
        http.send(body);

        http.onreadystatechange = function() {
            if (http.readyState == http.DONE) { // Выполнено?
                if(http.status && http.status === 200){ // Успешкое выполнение?
                    console.log("STATUS 200");
                    console.log(http.responseText);
                }
            }
        }
    }

    FileIO{
        id:file
        source: "C:/Users/Im/Desktop/vk.png"
        onTextChanged: {
            console.log("TEXT: ", text);
            func();
        }
    }

        var xmlhttp, text;
        xmlhttp = new XMLHttpRequest();
        xmlhttp.open('GET', 'C:/Users/Im/Desktop/vk.png', false);
        xmlhttp.send();
        xmlhttp.onreadystatechange = function() {
            if (http.readyState === http.DONE) {
                text = xmlhttp.responseText;
                console.log("TEXT: ", text);
            }
        }


*/
