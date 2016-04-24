import QtQuick 2.2
import QuickAndroid 0.1
import QuickAndroid.Styles 0.1
import QtQuick.Controls 1.4 as Control
import "../items"
import '../js/URLQuery.js' as URLQuery
import '../js/XHR.js' as XHR

Page {
    id: loginVkPage
    objectName: "LoginVkPage"

    property int userId
    property var authToken


    function processLoginSuccess(token) {
        loginWindow.visible = false
        authToken = token
        setStatus()
    }

    function setStatus() {
        var params = {
            access_token: loginVkPage.authToken,
            text: 'projectX status..:)'
        }

        function callback(request) {
            if (request.status == 200) {
                console.log('result', request.responseText)
                var result = JSON.parse(request.responseText)
                if (result.error) {
                    console.log('Error:', result.error.error_code,result.error.error_msg)
                    loginWindow.visible = true
                    loginWindow.login()
                    loginWindow.timeout()
                    //A.openDialog("Error","Code: "+result.error.error_code + " Message: " + result.error.error_msg, "OK");
                } else {
                    console.log('Success')
                    A.openDialog("Success","Now, see your status in VK", "Contune");
                }
            } else {
                console.log('HTTP:', request.status, request.statusText)
            }
        }

        XHR.sendXHR('POST', 'https://api.vk.com/method/status.set', callback, URLQuery.serializeParams(params))
    }

    LoginWindowVk {
        id: loginWindow
        anchors.fill: parent
        applicationId: '5289442'
        permissions: 'status'
        visible: false
        onSucceeded: processLoginSuccess(token)
        onFailed: {
            console.log('Login failed', error)
            Qt.quit()
        }
    }

    Connections{
        target: A.dialog
        onAccepted:{
            if(A.dialog.acceptButtonText==="Contune"){
                while(A.pageStack.count>1)
                    A.pageStack.pop(false);
                A.settings.loggined=true;
                present(Qt.resolvedUrl('./Lenta.qml'))
            }
        }
    }

    Component.onCompleted: {
        if(A.settings.accessTokenVk!=="")
            processLoginSuccess(A.settings.accessTokenVk)
        else{
            loginWindow.visible = true
            loginWindow.login()
            loginWindow.timeout()
        }
    }
}
