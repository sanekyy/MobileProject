import QtQuick 2.0
import QuickAndroid 0.1
import QuickAndroid.Private 0.1
import Qt.labs.settings 1.0
pragma Singleton


QtObject {
    id: a


    /// Device Independent Pixel value
    property real dp : 1;

    property real dpi : 72;

    // Настройки сервера
    property string serverIp : '127.0.0.1'//'31.134.153.162'

    property string serverPort : '3000'


    //"глобальные" переменные
    property var pageStack

    property var startPage

    property var settings

    property var dialog


    //Function

    function openDialog(title, text, acceptText, rejectText){
        dialog.title=title
        dialog.text=text;
        dialog.acceptButtonText=acceptText;
        dialog.rejectButtonText=rejectText===undefined ? "" : rejectText;
        dialog.open();
    }



    /* Return an URL of drawable resource by given the resource name and tintColor(optional)

      Example:
      A.drawable("ic_back"); // Return image://drawable/ic_back

      A.drawable("ic_back","#ffffff"); // Return image://drawable/ic_back?tintColor=%23deffffff

      A.drawable("ic_back","ffffff"); // Return image://drawable/ic_back?tintColor=ffffff
                                      // Without "#" is still working

     */

    /// Convert DP value to pixel value.
    function px(dp) {
        return dp * a.dp;
    }

    function drawable(name,tintColor) {
        var url = "image://drawable/" + name;
        if (tintColor !== undefined) {
            url += "?tintColor=" + escape(tintColor);
        }
        return url;
    }


    function setTimeout(func,interval) {
        return TimerUtils.setTimeout(func,interval);
    }


    Component.onCompleted: {
        dp = Device.dp;
        dpi = Device.dpi;
    }

}

