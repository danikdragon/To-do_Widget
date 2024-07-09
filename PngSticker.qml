import QtQuick
import QtQuick.Controls
import QtQuick.Layouts
import QtQuick.Controls.Material

ApplicationWindow {
    property string href: ""

    visible: true
    id: sticerWindow
    flags: Qt.FramelessWindowHint | Qt.WA_TranslucentBackground //| Qt.WindowStaysOnBottomHint
    width: imageSource.width + 10
    height: imageSource.height + 10
    Material.theme: Material.System
    Material.accent: "#9C27B0"

    ColumnLayout{
        anchors.fill: parent
        anchors.margins: 10
        Image{
            anchors.centerIn: parent
            id: imageSource
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
            if (mouse.button === Qt.RightButton) {
                contextMenu.visible = true
            }else{
                firstX = mouseX;
                firstY = mouseY;
            }
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
        }
    }
}
