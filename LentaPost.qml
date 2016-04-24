/*
  by sanekyy

    Элемент - отображающий пост в ленте.


       Column состоит из:
            Кучи текста с инфой о постек
*/



import QtQuick 2.2
import QuickAndroid 0.1
import "../pages"

Item{
    width: parent.width
    height: childrenRect.height+20*A.dp

    Paper {
        id: paper
        depth: 3
        anchors.horizontalCenter: parent.horizontalCenter
        width: texts.width+10*A.dp
        height: texts.height * A.dp
        Column{
            id:texts
            anchors.horizontalCenter: parent.horizontalCenter
            Text {
                anchors.horizontalCenter: parent.horizontalCenter
                text : "postId: " + postId
                type: Constants.smallText
                color : Constants.black87
            }
            Text {
                anchors.horizontalCenter: parent.horizontalCenter
                text : "userId: " + userId
                type: Constants.smallText
                color : Constants.black87
            }
            Text {
                anchors.horizontalCenter: parent.horizontalCenter
                text : "username: " + username
                type: Constants.smallText
                color : Constants.black87
            }
            Text {
                anchors.horizontalCenter: parent.horizontalCenter
                text : "fullName: " + fullName
                type: Constants.smallText
                color : Constants.black87
            }
            Text {
                anchors.horizontalCenter: parent.horizontalCenter
                text : "dateEnd: " + dateEnd
                type: Constants.smallText
                color : Constants.black87
            }
            Text {
                anchors.horizontalCenter: parent.horizontalCenter
                text : "description: " + description
                type: Constants.smallText
                color : Constants.black87
            }
            Text {
                anchors.horizontalCenter: parent.horizontalCenter
                text : "url: " + url
                type: Constants.smallText
                color : Constants.black87
            }
            Text {
                anchors.horizontalCenter: parent.horizontalCenter
                text : "tags: " + tags
                type: Constants.smallText
                color : Constants.black87
            }
            Text {
                anchors.horizontalCenter: parent.horizontalCenter
                text : "likes: " + likes
                type: Constants.smallText
                color : Constants.black87
            }
        }
        Ink{
            anchors.fill: parent
            onClicked: present(Qt.resolvedUrl('../pages/Post.qml'),{"postId":postId});
        }
    }
    // space
    Item {
        height: 8 * A.dp
        width: parent.width
        anchors.top:paper.top
    }
}
