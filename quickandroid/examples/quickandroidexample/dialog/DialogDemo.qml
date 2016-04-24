import QtQuick 2.0
import QuickAndroid 0.1
import QuickAndroid.Styles 0.1
//import "../theme"

Page {
    id:dialogPage
    objectName: 'dialogPage'
    actionBar: ActionBar {
        id: actionBar
        upEnabled: true
        title: qsTr("DIALOG")
        showTitle: true
        iconSource: A.drawable("ic_menu",Constants.black87)
        onActionButtonClicked: dialogPage.parent.initialPage.openNavigationDrawer();
        z: 10
    }

    Button {
        id: label
        text : "Press to launch dialog"
        anchors.centerIn: parent
        onClicked: {
            dialog.open();
        }
    }

    Dialog {
        id: dialog
        anchors.centerIn: parent
        title: "Dialog"
        Text {
            text: "Demo"
        }
        z: 20

        rejectButtonText: "OK"
    }
}
