import QtQuick
import QtQuick.Controls
import QtQuick.Layouts
import QtQuick.Controls.Material
import Qt.labs.platform

ApplicationWindow {
    property string href: ""
    visible: true
    id: sticerWindow
    flags: Qt.FramelessWindowHint | Qt.WA_TranslucentBackground //| Qt.WindowStaysOnBottomHint
    width: gif.width + 10
    height: gif.height + 10
    Material.theme: Material.System
    Material.accent: "#9C27B0"

    ColumnLayout{
        anchors.fill: parent
        anchors.margins: 10
        AnimatedImage{
            anchors.centerIn: parent
            id: gif
            source: href
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
                sticerWindow.x += mouseX - firstX;
                sticerWindow.y += mouseY - firstY;
            }
        }

        Menu {
            id: menu
            MenuItem {
                text: "Закрыть"
                onTriggered: {
                    sticerWindow.close()
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
            nameFilters: ["*.png *.jpg *.gif *.jfif"]
            onAccepted:{
                gif.source = shearePng.file;
                gif.playing = true;
            }
        }
    }
}
