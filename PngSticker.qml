import QtQuick
import QtQuick.Controls
import QtQuick.Layouts
import QtQuick.Controls.Material
import Qt.labs.platform

ApplicationWindow {
    property string href: ""
    visible: true
    id: stickerWindow
    flags: Qt.FramelessWindowHint | Qt.WA_TranslucentBackground //| Qt.WindowStaysOnBottomHint
    width: column.width
    height: column.height + titleText.contentHeight + 20
    //Material.theme: Material.System
    Material.accent: "#9C27B0"
    color: titleText.text ? "#1c1b1f" : "transparent"

    ColumnLayout{
        id: column
        width: gif.width
        height: gif.height
        AnimatedImage{
            anchors.top: parent.top
            id: gif
            source: href
        }
        Rectangle {
            anchors.top: gif.bottom
            Text{
                id: titleText
                width: gif.width
                wrapMode: Text.Wrap
                //anchors.fill: parent
                padding: 10
                color: isColorDark(stickerWindow.color)? "white" : "black"
                text: title
            }
        }
    }
    MouseArea {
        acceptedButtons: Qt.LeftButton | Qt.RightButton
        anchors.fill: parent
        property int firstX: 0
        property int firstY: 0
        onClicked: {
            if (mouse.button === Qt.RightButton)
                menu.open()
        }
        onPressed: {
            firstX = mouseX;
            firstY = mouseY;
        }
        onPositionChanged: {
            if (mouse.buttons & Qt.LeftButton) {
                stickerWindow.x += mouseX - firstX;
                stickerWindow.y += mouseY - firstY;
            }
        }

        Menu {
            id: menu
            MenuItem {
                text: "Закрыть"
                onTriggered: {
                    stickerWindow.close()
                }
            }
            MenuItem {
                text: "Изменить"
                onTriggered: {
                    shearePng.open();
                }
            }
        }
        FileDialog{
            id: shearePng
            nameFilters: ["*.png *.jpg *.jpeg *.gif *.bmp *.ico *.svg *.jfif *.webp" ]
            onAccepted:{
                gif.source = shearePng.file;
                gif.playing = true;
                titleText.text = titleArea.text
            }
        }
    }
}
