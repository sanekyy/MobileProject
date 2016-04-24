import QtQuick 2.5
import QuickAndroid 0.1
import QuickAndroid.Styles 0.1

BottomSheet {
    id : bottomSheet

    Column {
        width: bottomSheet.width

        Item {
            width: bottomSheet.width
            height: 56 * A.dp

            Text {
                anchors.verticalCenter: parent.verticalCenter
                text: "Add photo"
                color: Constants.black54
                x: 16 * A.dp
            }
        }

        ListItem {
            iconSource: A.drawable("ic_camera");
            iconSourceSize: Qt.size(24 * A.dp,24 * A.dp)
            title: "Take Photo"
            showDivider: false
            onClicked: {
                imagePicker.takePhoto();
                bottomSheet.close();
            }
        }

        ListItem {
            iconSource: A.drawable("ic_image");
            iconSourceSize: Qt.size(24 * A.dp,24 * A.dp)
            title: "Pick Image"
            showDivider: false
            onClicked: {
                imagePicker.pickImage();
                bottomSheet.close();
            }
        }
    }

}
