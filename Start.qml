
/*
 by sanekyy

    Пустая стартовая страничка, при необходимости отображает пустой ActionBar
    для перехода между страницами без мелькатия пустого экрана.

    Палень навигации недоступна.

    При создании этой страницы вызывается функция start(), в которой инициализируются
    необходимые глобальные переменные ( A.dialog=dialog ), для доступа из любого файла/модуля.
    Так же в зависимости от настроек пользователя и приложения производится открытие страницы для входа
    или же открывается лента.

    Описаны:
        NavigationDrawer - панель навигации ( выдвигающееся меню слева ( гамбургер ) )
        VisualDataModel - модель, в которой описаны элементы панели навигации


*/


import QtQuick 2.2
import QuickAndroid 0.1
import QuickAndroid.Styles 0.1
import "../items"



Page {
    id: startPage
    objectName: "StartPage"


    // Массив страниц для панели навигации
    property var pages: [
        {
            publicName: "Lenta", pageName: "Lenta", objectName: "LentaPage",
        },

        {
            publicName: "New Post", pageName: "NewPost", objectName: "NewPostPage",
        },

        {
            publicName: "My Page", pageName: "My", objectName: "MyPage",
        }

    ];


    // При переходе между Login->SignUp бар не должно быть видно, однако видно при переходе например
    // между Lenta->NewPost с помощью панели навигации, для незаметного переключения страниц
    property bool actionBarVisible:false


    // Вызывается при запуске приложения
    function start(){

        // инициализация "глобальных" переменных
        A.startPage=startPage;
        A.pageStack=startPage.parent;
        A.settings=settings;
        A.dialog=dialog;

        // Выводим в лог все настройки
        console.log('serverIp:', A.serverIp);
        console.log('serverPort:', A.serverPort);
        console.log('loggined:', A.settings.loggined);
        console.log('username:', A.settings.username);
        console.log('password:', A.settings.password);
        console.log('userId:', A.settings.userId);
        console.log('session:', A.settings.session);
        console.log('accessTokenVk:', A.settings.accessTokenVk);


        // если залогинен, login(), иначе открываем страницу для входа
        if (A.settings.loggined&&A.settings.accessTokenVk===""){
            login( A.settings.username, A.settings.password);
        }
        else if(A.settings.accessTokenVk!==""){
            while(A.pageStack.count>1)
                A.pageStack.pop(false);
            present(Qt.resolvedUrl("Lenta.qml"));

            // Запуск таймера, как только лента откроется, actionBarVisible=true;
            visibleOnActionBar();
        }
        else{
            present(Qt.resolvedUrl('./Login.qml'));
        }
    }

    // аутентификация пользователя на сервере, при положетильном ответе открываем ленту
    function login(username, password) {

        // Создаём json для запроса к серверу
        var jsonReq = JSON.stringify({username: username, password: password});

        // Создаём http объект, открываем и настраиваем запрос, отправляем json
        var request = new XMLHttpRequest();
        request.open("POST", "http://" + A.serverIp + ":" + A.serverPort + "/login");;
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

                            // Записываем настройки
                            A.settings.userId=jsonRes.userId;
                            A.settings.username=username;
                            A.settings.password=password;
                            A.settings.loggined=true;
                            //settings.session=jsonRes.session;

                            // Очищаем стек страниц ( например, если открыта LoginPage )
                            while(A.pageStack.count>1)
                                A.pageStack.pop(false);
                            present(Qt.resolvedUrl("Lenta.qml"));

                            // Запуск таймера, как только лента откроется, actionBarVisible=true;
                            visibleOnActionBar();
                            return;
                        }
                        // Обработка ошибки, сообщение пользователю...
                        A.openDialog("Login", jsonRes.err.description, "OK");
                        return
                    }
                }
                // Если запрос выполнен, но сервер не ответил кодом 200 ( 200 - успешное выполнение )
                A.openDialog("Error", "Server don't answer", "OK");
                console.log('Server error');
            }
        };
    }

    // Рекурсивный таймер, проверяет каждые 100мс состояние PageStack
    // Если running=false, значит Lenta открылась и ActionBar можно показывать
    function visibleOnActionBar(){
        A.setTimeout(function(){
            if(A.pageStack.running)
                visibleOnActionBar();
            else
                A.startPage.actionBarVisible=true;
        }, 100);
    }

    // Открывает панель навигации
    function openNavigationDrawer(){
        navigation.show();
    }

    // ActionBar для отсутствия белого экрана при переключении между экранами
    actionBar: ActionBar {
        id: actionBar
        upEnabled: true
        visible:actionBarVisible
        title: qsTr("")
        showTitle: true
        iconSource: A.pageStack.count>2? A.drawable("ic_arrow_back",Constants.black87):A.drawable("ic_menu",Constants.black87)
        //onActionButtonClicked:{ A.pageStack.count>2? back():A.startPage.openNavigationDrawer();}
        z: 10
    }

    NavigationDrawer { // Боковое меню слева
        id: navigation
        parent: A.pageStack.topPage

        // Список пунктов меню
        ListView {
            id:pagesList
            width:parent.width
            height: parent.height - logOutButtom.height
            z:parent.z
            model: visualDataModel
        }

        // Log Out Button
        RaisedButton{
            id: logOutButtom
            text: "Log out"
            height: 35*A.dp
            width: parent.width
            anchors.horizontalCenter: parent.horizontalCenter
            anchors.top: pagesList.bottom
            z:parent.z
            onClicked:{
                navigation.hide();
                // Сбрасываем все настройки закрываем все страницы и открываем LoginPage
                A.settings.loggined=false;
                A.settings.username="";
                A.settings.password="";
                A.startPage.actionBarVisible=false;
                A.settings.accessTokenVk="";
                while(A.pageStack.count>1)
                    pop(false);
                present(Qt.resolvedUrl('./Login.qml'));
            }
        }
    }

    // Визуальная модель списока пунктов меню в панели навигации
    VisualDataModel{
        id: visualDataModel
        delegate: ListItem{
            title: modelData.publicName
            onClicked: {
                navigation.hide();

                // Если это та же самая страница, ничего не делаем
                if(A.pageStack.topPage.objectName===(modelData.objectName))
                    return;

                // Проверяем, есть ли уже данная страница в стеке
                var isClicedPageInStack=false;
                for (var i=0; i<A.pageStack.count; i++){
                    if (A.pageStack.pages[i].objectName===(modelData.objectName)){
                        isClicedPageInStack=true;
                        break;
                    }
                }
                // Если страница есть в стеке, закрываем страницы пока не дойдёт до выбранной
                if(isClicedPageInStack){
                    while(A.pageStack.count>(i+1))
                        A.pageStack.pop(false);
                    return;
                }

                // Если страница ещё не открыта очищаем стек страниц и открываем выбранную
                while (A.pageStack.count>1)
                    A.pageStack.pop(false);
                present(Qt.resolvedUrl(modelData.pageName+".qml"),{}, false);
            }
        }
        model:pages
    }
}
