import QtQuick
import QtQuick.Controls
import QtQuick.Layouts
import QtQuick.Controls.Material

ApplicationWindow {
    function isColorDark(color) {
        var colorComponents = Qt.rgba(color.r, color.g, color.b, color.a);
        var r = colorComponents.r * 255;
        var g = colorComponents.g * 255;
        var b = colorComponents.b * 255;
        var brightness = (r * 299 + g * 587 + b * 114) / 1000;
        return brightness < 128;
    }
    visible: true
    id: sticerWindow
    property string title: ""
    property string description: ""
    flags: Qt.FramelessWindowHint | Qt.WA_TranslucentBackground //| Qt.WindowStaysOnBottomHint
    width: titleSticer.width < descriptionSticer.width ?
               (descriptionSticer.width < 200 ? 100 : descriptionSticer.width + 40) :
               (titleSticer.width < 200 ? 100 : titleSticer.width + 40)

    height: descriptionSticer.height < 200 ? 100 : descriptionSticer.height + 40
    Material.theme: Material.System
    Material.accent: "#9C27B0"
    ColumnLayout{
        anchors.fill: parent
        anchors.margins: 10
        Text {
            id: titleSticer
            font.bold: true
            text: title
            color: isColorDark(sticerWindow.color) ? "white" : "black"
        }
        Text {
            id: descriptionSticer
            text: description
            color: isColorDark(sticerWindow.color) ? "white" : "black"
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
            MenuItem { text: "Редактировать" }
        }
    }
}
