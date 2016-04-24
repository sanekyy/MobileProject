/*
  by sanekyy

    Список, отображающий фотографии.

*/

import QtQuick 2.5

import QuickAndroid 0.1
import QuickAndroid.Styles 0.1
import QtQuick.Layouts 1.2

ListView {
    id: photoList
    keyNavigationWraps: false
    snapMode: ListView.NoSnap
    layoutDirection: Qt.RightToLeft
    boundsBehavior: Flickable.DragAndOvershootBounds
    flickableDirection: Flickable.HorizontalFlick
    orientation: ListView.Horizontal
    model: photoModel
    spacing: 20*A.dp
    preferredHighlightBegin: width / 2 -150/2*A.dp
    preferredHighlightEnd: width / 2 + 150/2*A.dp
    highlightRangeMode: ListView.StrictlyEnforceRange
    add: Transition {
        NumberAnimation { property: "opacity"; from: 0; to: 1.0; duration: 400 }
        NumberAnimation { property: "scale"; from: 0; to: 1.0; duration: 400 }
    }
    displaced: Transition {
        NumberAnimation { properties: "x,y"; duration: 400; easing.type: Easing.OutBack }
    }

    delegate: Rectangle {
        id:delegateRect
        property string imageUrl
        height: parent.height
        width: 150*A.dp
        color: index? "white" : "#384851"
        anchors.margins: 10*A.dp
        Image{
            id:image
            anchors.fill: parent
            visible: true
            source: model.sourceImg //images[index].url
            fillMode: Image.PreserveAspectFit
        }
        MouseArea{
            anchors.fill: image
            onClicked: {
                photoBottomSheet.open()
            }
        }
    }
}
