import QtQuick 2.0
import QtQuick.Window 2.0
import QtWebKit 3.0
//import QtWebView 1.0
import QuickAndroid 0.1
import "../js/URLQuery.js" as URLQuery

Item {
    id: loginWindow

    property string oldUrl;
    property bool oldLoading;
    property bool timeoutRunning:true
    property string applicationId
    property string permissions
    property var finishRegExp: /^https:\/\/oauth.vk.com\/blank.html/

    signal succeeded(string token)
    signal failed(string error)
    signal changed();


    function timeout(){
        A.setTimeout(function(){
            console.log("Timeout");

            if(oldLoading!=webView.loading){
                console.log("loadingChanged");
                oldLoading=webView.loading;
                if(!oldLoading)
                    changed();
            }
            if(oldUrl!=webView.url.toString()){
                console.log("urlChanged");
                oldUrl=webView.url.toString();
                changed();
            }
            if(finishRegExp.test(webView.url.toString())){
                loginWindow.visible=false;
                changed();
            }
            if(timeoutRunning)
                timeout();
        },100);
    }


    function login() {
        var params = {
            client_id: applicationId,
            display: 'popup',
            response_type: 'token',
            redirect_uri: 'https://oauth.vk.com/blank.html',
            v: '5.45'
        }
        if (permissions) {
            params['scope'] = permissions
        }

        webView.url = "https://oauth.vk.com/authorize?%1".arg(URLQuery.serializeParams(params))


    }

    onChanged: {
        console.log("REQUEST:",webView.url.toString())


        if (!finishRegExp.test(webView.url.toString())) {
            return
        }

        var result = URLQuery.parseParams(webView.url.toString())
        if (!result) {
            loginWindow.failed("Wrong responce from server", webView.url.toString())
            return
        }
        if (result.error) {
            loginWindow.failed("Error", result.error, result.error_description)
            return
        }
        if (!result.access_token) {
            loginWindow.failed("Access token absent", webView.url.toString())
            return
        }

        timeoutRunning=false;
        A.settings.accessTokenVk=result.access_token
        succeeded(A.settings.accessTokenVk)
        return
    }


    WebView {
        id: webView
        anchors.fill: parent
    }
}
